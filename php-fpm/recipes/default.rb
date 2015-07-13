# install PHP-FPM
version = node['php-fpm']['version']
package_version = version.sub('.', '')

if not ['5.4', '5.5', '5.6'].include?(version)
  Chef::Application.fatal!("Unsupported PHP-FPM version #{version}", 1)
end

yum_package "php#{package_version}-fpm" do
  action :install
end

# define PHP-FPM system service
service 'php-fpm' do
  service_name "php-fpm-#{version}"
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end

# configure PHP-FPM
template "/etc/php-fpm-#{version}.conf" do
  source 'php-fpm.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :reload, 'service[php-fpm]', :immediately
end

template "/etc/php-#{version}.ini" do
  source 'php.ini.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :reload, 'service[php-fpm]', :immediately
end

template "/etc/php-fpm-#{version}.d/www.conf" do
  source 'www.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :reload, 'service[php-fpm]', :immediately
end
