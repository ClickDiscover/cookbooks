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

# symlink static files
link '/srv/www/centrifuge_landers/current/static' do
  to '/srv/www/centrifuge/current/static'
  ignore_failure true
  owner node[:opsworks][:deploy_user][:user]
  group node[:opsworks][:deploy_user][:group]
end
