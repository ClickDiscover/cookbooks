#
template '/etc/nginx/conf.d/site.conf' do
  source 'site.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'

  variables({
    # replace hostname's last dash with dot; reverse server's hostname,
    # then replace first dash, then reverse result again
    :domain => node[:hostname].reverse.sub('-', '.').reverse,
    :use_ssl => true
  })
  notifies :restart, 'service[nginx]', :immediately
end
