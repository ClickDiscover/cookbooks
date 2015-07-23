include_recipe 'deploy'

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
template '/srv/www/centrifuge/current/config.php' do
  source 'centrifuge.config.php.erb'
  owner node[:opsworks][:deploy_user][:user]
  group node[:opsworks][:deploy_user][:group]
  mode '0640'
end

begin
  # symlink static files
  link '/srv/www/centrifuge-landers/current/static' do
    to '/srv/www/centrifuge/current/static'
    owner node[:opsworks][:deploy_user][:user]
    group node[:opsworks][:deploy_user][:group]
  end
rescue Errno::ENOENT
  log 'message' do
    message "******Skipping /srv/www/centrifuge/current/static -> /srv/www/centrifuge-landers/current/static symlink creation******"
    level :warn
  end
end
