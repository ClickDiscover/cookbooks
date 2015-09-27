include_recipe 'deploy'

www_dir = "/srv/www"
centrifuge = "#{www_dir}/centrifuge"
centrifuge_landers = "#{www_dir}/centrifuge_landers"

stage2_pid = '/var/lib/aws/opsworks/cache.stage2/chef-client-running.pid'
deploy_json = '/tmp/deploy.json'
deploy_setup_log = '/tmp/deploy_setup.log'
chef_client = '/opt/aws/opsworks/current/bin/chef-client'
# update custom cookbooks

# setup
stage2 = '/var/lib/aws/opsworks/client.stage2.rb'
stage2_cmd = 'opsworks_rubygems,nginx,php-fpm,collectd,nginx::collectd,statsd,php-fpm::collectd,php-fpm::aerospike'

# create temporary json file
execute "opsworks-agent-cli get_json > #{deploy_json}"

# setup
log 'message' do
  message '******Running Setup******'
  level :info
end

# rename the pid file so another copy of chef can run
execute "mv #{stage2_pid} #{stage2_pid}.backup"

execute "#{chef_client} --chef-zero-port 8890 -j #{deploy_json} -L #{deploy_setup_log} -c #{stage2} -o #{stage2_cmd}"

# rename the pid file back
execute "mv #{stage2_pid}.backup #{stage2_pid}"

# remove temporary json file
file deploy_json do
  action :delete
end

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
