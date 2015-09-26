# ensure /home/ec2-user directory exists and has correct permissions
file '/home/ec2-user' do
  mode '0711'
  owner 'ec2-user'
  group 'ec2-user'
end

# ensure /home/ec2-user/www directory exists
directory '/home/ec2-user/www' do
  mode '0755'
  owner 'ec2-user'
  group 'ec2-user'
  action :create
  recursive true
end
