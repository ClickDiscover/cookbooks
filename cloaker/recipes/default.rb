user = 'ec2-user'
group = 'ec2-user'

cloaker_dir = "/home/#{user}/www"
index_path = "#{cloaker_dir}/index.php"

# the directory to download ['cloaker']['url'] to
wgetdir = '/tmp/website'

# don't proceed if cloaker is already installed and reinstall flag isn't set
if File.exists?(index_path) and !node['cloaker']['reinstall']
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

# remove cloaker_dir (the web server root) if it already exists
# so there is no stalled files while running as an ad-hoc command
if node['cloaker']['url']
  directory "#{cloaker_dir}" do
    action :delete
    recursive true
  end
end

# set up cloaker script
template index_path do
  source 'index.php.erb'
  owner user
  group group
  mode '0644'
end

if node['cloaker']['url']
  # download URL
  execute "/usr/bin/wget -mkEpnp -nH -P /tmp/website -e robots=off #{node['cloaker']['url']}"

  # rename index.php if it exists in the downloaded data
  if File.exist?("#{wgetdir}/index.php")
    execute "/bin/mv #{wgetdir}/index.php #{wgetdir}/index.php.remote"
  end

  # copy contents of the tmp directory to web server root
  execute "/usr/bin/rsync #{wgetdir}/ #{cloaker_dir}/"

  # remove the tmp directory
  directory "#{wgetdir}" do
    action :delete
    recursive true
  end
end
