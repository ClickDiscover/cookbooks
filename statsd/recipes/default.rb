# install statsd
include_recipe "statsd::install"

# configure the service
include_recipe "statsd::configure"

# define statsd service
service 'statsd' do
  service_name 'statsd'
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end

template '/etc/init.d/statsd' do
  source 'initd.conf.erb'
  mode 0755
  notifies :restart, 'service[statsd]', :delayed
end
