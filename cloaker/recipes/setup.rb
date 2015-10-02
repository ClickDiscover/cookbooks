# ensure /home/ec2-user directory exists and has correct permissions
directory '/home/ec2-user' do
  mode '0711'
  owner 'ec2-user'
  group 'ec2-user'
  action :create
end

# ensure cloaker directory exists
directory node['cloaker']['web_root'] do
  owner node['cloaker']['user']
  group node['cloaker']['group']
  mode '0755'
  action :create
  recursive true
end
