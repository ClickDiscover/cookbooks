#
cloaker_dir = node['cloaker']['uri'].split('/')[0...-1].join('/')
cloaker_abs_dir = "#{node['cloaker']['web_root']}/#{cloaker_dir}"
cloaker_index = "#{node['cloaker']['web_root']}/#{node['cloaker']['uri']}"

# don't proceed if cloaker is already installed and reinstall flag isn't set
if File.exists?(cloaker_index) and !node['cloaker']['reinstall']
  raise "Unable to set up cloaker: already installed"
end

log "Installing cloaker to #{cloaker_index}"

# don't proceed if id or name aren't set
if not node['cloaker']['id']
  raise "Unable to set up cloaker: id isn't set"
end

# don't proceed if id or name aren't set
if not node['cloaker']['name']
  raise "Unable to set up cloaker: name isn't set"
end

# remove web root
directory node['cloaker']['web_root'] do
  action :delete
  recursive true
end
# create cloaker dir
directory cloaker_full_dir do
  owner node['cloaker']['user']
  group node['cloaker']['group']
  mode '0755'
  action :create
  recursive true
end

# install cloaker script
template cloaker_index do
  source 'index.php.erb'
  owner node['cloaker']['user']
  group node['cloaker']['group']
  mode '0644'
end
