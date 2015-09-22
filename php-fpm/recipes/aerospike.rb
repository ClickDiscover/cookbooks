# install Aerospike PHP Client
# php version
version = node['php-fpm']['version']
pv = version.sub('.', '')

return if File.exists?("/etc/php-#{version}.d/aerospike.ini") and File.exists?("/usr/lib64/php/#{version}/modules/aerospike.so")

yum_package "php#{pv}-devel" do
  action :install
end

directory "#{node['php-fpm']['build_dir']}" do
  action :create
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
end

execute 'composer require aerospike/aerospike-client-php "*"' do
  cwd node['php-fpm']['build_dir']
end

execute 'find vendor/aerospike/aerospike-client-php/ -name "*.sh" -exec chmod +x {} \;' do
  cwd node['php-fpm']['build_dir']
end

execute 'composer run-script post-install-cmd' do
  cwd "#{node['php-fpm']['build_dir']}/vendor/aerospike/aerospike-client-php"
end

execute "cp #{node['php-fpm']['build_dir']}/vendor/aerospike/aerospike-client-php/src/aerospike/modules/aerospike.so /usr/lib64/php/#{version}/modules/aerospike.so" do
  cwd node['php-fpm']['build_dir']
end

execute "strip -s /usr/lib64/php/#{version}/modules/aerospike.so"

template "/etc/php-#{version}.d/aerospike.ini" do
  source 'aerospike.ini.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :reload, 'service[php-fpm]', :delayed
end

directory "#{node['php-fpm']['build_dir']}/vendor" do
  action :delete
  recursive true
end
