# install Aerospike PHP Client
# php version
version = node['php-fpm']['version']
pv = version.sub('.', '')

return if File.exists?("/etc/php-#{version}.d/aerospike.ini") and File.exists?("/usr/lib64/php/#{version}/modules/aerospike.so")

yum_package "php#{pv}-devel" do
  action :install
end

execute 'composer require' do
  command 'composer require aerospike/aerospike-client-php "*"'
  cwd "#{build_dir}"
end

execute 'make *.sh files executable' do
  command 'find vendor/aerospike/aerospike-client-php/ -name "*.sh" -exec chmod +x {} \;'
  cwd "#{build_dir}"
end

execute 'composer run-script post-install-cmd' do
  command 'composer run-script post-install-cmd'
  cwd "#{build_dir}/vendor/aerospike/aerospike-client-php"
end

file "/usr/lib64/php/#{version}/modules/aerospike.so" do
  content IO.read("#{build_dir}/vendor/aerospike/aerospike-client-php/src/aerospike/modules/aerospike.so")
  action :create
  owner 'root'
  group 'root'
  mode '0644'
  notifies :reload, 'service[php-fpm]', :delayed
end

template "/etc/php-#{version}.d/aerospike.ini" do
  source 'aerospike.ini.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :reload, 'service[php-fpm]', :delayed
end

directory "#{build_dir}/vendor" do
  action :delete
  recursive true
end
