yum_package 'collectd' do
  action :install
end

yum_package 'collectd-curl' do
  action :install
end

yum_package 'collectd-nginx' do
  action :install
end

# define nginx system service
service 'collectd' do
  service_name 'collectd'
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end

template '/etc/collectd.conf' do
  source 'collectd.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :reload, 'service[collectd]', :immediately
end

# template '/etc/collectd.d/nginx.conf' do
#   source 'collectd.conf.erb'
#   owner 'root'
#   group 'root'
#   mode '0644'
#   notifies :reload, 'service[collectd]', :immediately
# end

# template '/etc/collectd.conf' do
#   source 'collectd.conf.erb'
#   owner 'root'
#   group 'root'
#   mode '0644'
#   notifies :reload, 'service[collectd]', :immediately
# end
