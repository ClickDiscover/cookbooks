template '/etc/collectd.d/php-fpm.conf' do
  source 'collectd.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :reload, 'service[collectd]', :immediately
end

template '/etc/collectd.d/php-fpm.types.db' do
  source 'collectd.types.db.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :reload, 'service[collectd]', :immediately
end

