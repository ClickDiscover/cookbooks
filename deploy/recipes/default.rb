include_recipe 'deploy'

www_dir = "/srv/www"
centrifuge = "#{www_dir}/centrifuge"
centrifuge_landers = "#{www_dir}/centrifuge_landers"

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
if node[:deploy].has_key? :centrifuge
  template "#{centrifuge}/current/config.php" do
    source 'version2.config.php.erb'
    owner node[:opsworks][:deploy_user][:user]
    group node[:opsworks][:deploy_user][:group]
    mode '0644'

    deploy_db = node[:deploy][:centrifuge][:database]
    db = {
      'host' => deploy_db[:host],
      'dbname' =>  deploy_db[:database],
      'port' => deploy_db[:port],
      'user' => deploy_db[:username],
      'password' => deploy_db[:password]
    }
    db_str = db.map{|k,v| "#{k}=#{v}"}.join(';')

    variables({
      :pdo_url => "pgsql:#{db_str}"
    })
  end
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
