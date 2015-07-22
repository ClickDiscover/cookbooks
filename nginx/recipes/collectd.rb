
template '/etc/collectd.d/nginx.conf' do
  source 'collectd.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :reload, 'service[collectd]', :immediately
end

