# ensure cloaker directory exists
directory node['cloaker']['dir'] do
  owner node['cloaker']['user']
  group node['cloaker']['group']
  mode '0755'
  action :create
  recursive true
end
