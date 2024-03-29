# install nginx
yum_package 'nginx' do
  action :install
end

# define nginx system service
service 'nginx' do
  service_name 'nginx'
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end

# configure nginx
template '/etc/nginx/nginx.conf' do
  source 'nginx.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :reload, 'service[nginx]', :immediately
end

htpasswd node['nginx']['htpasswd'] do
  user     node['nginx']['admin_user']
  password node['nginx']['admin_password']
end

template '/etc/nginx/conf.d/site.conf' do
  source 'site.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'

  variables({
    # replace hostname's last dash with dot; reverse server's hostname,
    # then replace first dash, then reverse result again
    :domain => node[:hostname].reverse.sub('-', '.').reverse,
    :use_ssl => false
  })
  notifies :restart, 'service[nginx]', :immediately
end
