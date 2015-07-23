# install PHP-FPM
version = node['php-fpm']['version']
# php version
pv = version.sub('.', '')

if not ['5.4', '5.5', '5.6'].include?(version)
  Chef::Application.fatal!("Unsupported PHP-FPM version #{version}", 1)
end

["php#{pv}-mbstring", "php#{pv}-pdo", "php#{pv}-pgsql", "php#{pv}-fpm"].each {|x|
  yum_package "#{x}" do
    action :install
    notifies :reload, 'service[php-fpm]', :delayed
  end
}

# install composer
execute 'install-composer' do
  user 'root'
  group 'root'

  command <<-EOH
    /usr/bin/curl -sS https://getcomposer.org/installer | /usr/bin/php -- --install-dir=/usr/local/bin --filename=composer
  EOH
end

# define PHP-FPM system service
service 'php-fpm' do
  service_name "php-fpm-#{version}"
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end

# fix session dir permissions
directory "/var/lib/php/#{version}/session/" do
  owner 'root'
  group node['php-fpm']['group']
  mode '0770'
  action :create
end

# configure PHP-FPM
template "/etc/php-fpm-#{version}.conf" do
  source 'php-fpm.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :reload, 'service[php-fpm]', :delayed
end

template "/etc/php-#{version}.ini" do
  source 'php.ini.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :reload, 'service[php-fpm]', :delayed
end

template "/etc/php-fpm-#{version}.d/www.conf" do
  source 'www.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :reload, 'service[php-fpm]', :immediately
end
