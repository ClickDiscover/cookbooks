# don't proceed if cloaker is already installed and reinstall flag isn't set
if File.exists?(node['cloaker']['index']) and !node['cloaker']['reinstall']
  raise "Unable to set up cloaker: already installed"
end

# don't proceed if id or name aren't set
if not node['cloaker']['id']
  raise "Unable to set up cloaker: id isn't set"
end

# don't proceed if id or name aren't set
if not node['cloaker']['name']
  raise "Unable to set up cloaker: name isn't set"
end

# recreate cloaker directory
directory node['cloaker']['dir'] do
  action :delete
  recursive true
end
directory node['cloaker']['dir'] do
  owner node['cloaker']['user']
  group node['cloaker']['group']
  mode '0755'
  action :create
  recursive true
end

log "Debug: #{node['cloaker']['index']}"
log "Debug: #{node['cloaker']['dir']}"

# set up cloaker script
template node['cloaker']['index'] do
  source 'index.php.erb'
  owner node['cloaker']['user']
  group node['cloaker']['group']
  mode '0644'
  force_unlink true
end
