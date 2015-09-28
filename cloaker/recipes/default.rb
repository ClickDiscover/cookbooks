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

# cloaker installation paths
cloaker_dirs = []
cloaker_paths = []

if node['cloaker']['install_root'] then
  cloaker_dirs.push(node['cloaker']['dir'])
  cloaker_paths.push(node['cloaker']['index'])
end
if node['cloaker']['cloaker_directory'] then
  cloaker_dir = "#{node['cloaker']['dir']}/#{node['cloaker']['cloaker_directory']}"
  cloaker_dirs.push("#{cloaker_dir}")
  cloaker_paths.push("#{cloaker_dir}/index.php")
end

# remove www root
directory node['cloaker']['dir'] do
  action :delete
  recursive true
end
# create cloaker dirs
cloaker_dirs.each do |dir|
  directory dir do
    owner node['cloaker']['user']
    group node['cloaker']['group']
    mode '0755'
    action :create
    recursive true
  end
end

# install cloaker script
cloaker_paths.each do |path|
  template path do
    source 'index.php.erb'
    owner node['cloaker']['user']
    group node['cloaker']['group']
    mode '0644'
  end
end
