user = 'ec2-user'
group = 'ec2-user'

# don't proceed if cloaker is already installed and reinstall flag isn't set
if File.exists?("/home/#{user}/www/index.php") and !node['cloaker']['reinstall']
  log 'message' do
    message "******Skipping Cloaker index.php creation as it already exists and the 'reinstall' flag isn't set******"
    level :info
  end
  return
end

# don't proceed if id or name aren't set
if not node['cloaker']['id']
  raise "Unable to set up cloaker: id isn't set"
end

# don't proceed if id or name aren't set
if not node['cloaker']['name']
  raise "Unable to set up cloaker: name isn't set"
end

# set up cloaker script
template "/home/#{user}/www/index.php" do
  source 'index.php.erb'
  owner user
  group group
  mode '0644'
end
