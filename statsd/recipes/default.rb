
include_recipe "statsd::install"

# configure the service
include_recipe "statsd::configure"

template '/etc/init.d/statsd' do
  source 'initd.conf.erb'
  mode 0644
  notifies :restart, 'service[statsd]', :delayed
end

service 'statsd' do
  service_name 'statsd'
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end

