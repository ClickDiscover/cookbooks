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

# configure Centrifuge
template "#{centrifuge}/current/config.php" do
  source 'centrifuge.config.php.erb'
  owner node[:opsworks][:deploy_user][:user]
  group node[:opsworks][:deploy_user][:group]
  mode '0644'
end

# symlink static files
link "#{centrifuge}/current/static" do
  to "#{centrifuge_landers}/current/static"
  ignore_failure true
  owner node[:opsworks][:deploy_user][:user]
  group node[:opsworks][:deploy_user][:group]
end

# install dependencies via composer
execute 'composer-deps' do
  ignore_failure true
  user 'ec2-user'
  group 'ec2-user'

  command <<-EOH
    /usr/local/bin/composer install -d #{centrifuge}/current
  EOH
end
