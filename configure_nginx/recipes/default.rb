# define nginx system service
service 'nginx' do
  service_name 'nginx'
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end

# configure nginx
template '/etc/nginx/nginx.conf' do
  force_unlink true
  source 'nginx.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :reload, 'service[nginx]', :immediately
end

template '/etc/nginx/conf.d/site.conf' do
  force_unlink true
  source 'site.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[nginx]', :immediately
end
