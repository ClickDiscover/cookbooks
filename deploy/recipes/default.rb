require 'json'
require 'aws-sdk'
include_recipe 'deploy'

www_dir = "/srv/www"
centrifuge = "#{www_dir}/centrifuge"
centrifuge_landers = "#{www_dir}/centrifuge_landers"

# DO NOT override this via custom JSON, we should set it automatically when needed to avoid infinite loop
if not node['setup']['force_deploy'] then
  # initialize OpsWorks API
  opsworks = AWS::OpsWorks::Client.new(
    access_key_id: node['setup']['access_key'],
    secret_access_key: node['setup']['secret_key']
  )

  opsworks_instance = opsworks.describe_instances('instance_ids' => [node['opsworks']['instance']['id']]).instances[0]
  opsworks_layer = opsworks.describe_layers('layer_ids' => [opsworks_instance.layer_ids[0]]).layers[0]
  stage2_cmd = 'opsworks_rubygems,' + opsworks_layer.custom_recipes.setup.join(',')

  # create temporary json file
  execute "opsworks-agent-cli get_json > #{node['setup']['json']}"

  # update custom cookbooks
  log '******Updating Custom Cookbooks******'
  execute "#{node['setup']['chef_client']} --chef-zero-port 8890 -j #{node['setup']['json']} -c #{node['setup']['stage1']} -o #{node['setup']['stage1_cmd']}"

  # setup
  log '******Running Setup******'

  # rename the pid file so another copy of chef can run
  execute "mv #{node['setup']['stage2_pid']} #{node['setup']['stage2_pid']}.backup"

  execute "#{node['setup']['chef_client']} --chef-zero-port 8890 -j #{node['setup']['json']} -L #{node['setup']['log']} -c #{node['setup']['stage2']} -o #{stage2_cmd}"

  # deploy
  log '******Running Deploy******'

  # override ['setup']['force_deploy'] attribute
  j = ::JSON.parse(File.read(node['setup']['json']))
  j['setup']['force_deploy'] = true
  File.open(node['setup']['json'], 'w') do |f|
    puts ::JSON.pretty_generate(j)
    f.write(::JSON.pretty_generate(j))
  end

  execute "#{node['setup']['chef_client']} --chef-zero-port 8890 -j #{node['setup']['json']} -L #{node['setup']['log']} -c #{node['setup']['stage2']} -o deploy::default"

  # rename the pid file back
  execute "mv #{node['setup']['stage2_pid']}.backup #{node['setup']['stage2_pid']}"

  # remove temporary json file
  file node['setup']['json'] do
    action :delete
    ignore_failure true
  end
else
  # at this point, node['setup']['force_deploy'] should be set in Chef JSON configuration (node['setup']['json'])

  # deploy applications
  node[:deploy].each do |application, deploy|
    opsworks_deploy_dir do
      user deploy[:user]
      group deploy[:group]
      path deploy[:deploy_to]
    end

    opsworks_deploy do
      deploy_data deploy
      app application
    end
  end

  # Setup logging
  directory node[:centrifuge][:log_path] do
    owner 'nginx'
    group 'nginx'
    mode '0755'
    action :create
  end

  template "/etc/logrotate.d/centrifuge" do
    source 'logrotate.erb'
    owner 'root'
    group 'root'
    mode '0644'
  end

  # configure Centrifuge
  template "#{centrifuge}/current/config.php" do
    source 'version2.config.php.erb'
    owner node[:opsworks][:deploy_user][:user]
    group node[:opsworks][:deploy_user][:group]
    mode '0644'
  end

  # symlink static files
  # ['static', 'landers'].each {|x|
  # }
  link "#{centrifuge}/current/www/static" do
    to "#{centrifuge_landers}/current/static"
    ignore_failure true
    owner node[:opsworks][:deploy_user][:user]
    group node[:opsworks][:deploy_user][:group]
  end

  link "#{centrifuge}/current/templates/landers" do
    to "#{centrifuge_landers}/current/landers"
    ignore_failure true
    owner node[:opsworks][:deploy_user][:user]
    group node[:opsworks][:deploy_user][:group]
  end

  # convience symlinks in ~
  ['centrifuge', 'centrifuge_landers'].each {|x|
    link "/home/#{node[:opsworks][:deploy_user][:user]}/#{x}" do
      to "#{www_dir}/#{x}/current"
      ignore_failure true
      owner node[:opsworks][:deploy_user][:user]
      group node[:opsworks][:deploy_user][:group]
    end
  }

  # install dependencies via composer
  execute 'composer-deps' do
    cwd "#{centrifuge}/current"
    user 'ec2-user'
    group 'ec2-user'

    command '/usr/local/bin/composer install'
  end
end
