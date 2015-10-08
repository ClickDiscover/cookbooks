# install nginx
package 'nginx'

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
