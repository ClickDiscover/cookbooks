# install required packages
['collectd', 'collectd-curl', 'collectd-curl_xml', 'collectd-nginx'].each {|x|
  yum_package "#{x}" do
    action :install
  end
}

# define collectd system service
service 'collectd' do
  service_name 'collectd'
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end
# configure collectd
source = [node[:librato][:application], node[:librato][:environment], node[:hostname]].compact.join('.')

template '/etc/collectd.conf' do
  source 'collectd.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'

  variables({
    :source => source
  })
  notifies :reload, 'service[collectd]', :immediately
end
