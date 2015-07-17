# ensure /home/ec2-user directory exists and has correct permissions
directory '/home/ec2-user' do
  owner 'ec2-user'
  group 'ec2-user'
  mode '0711'
  action :create
end

# ensure /home/ec2-user/www directory exists
directory '/home/ec2-user/www' do
  owner 'ec2-user'
  group 'ec2-user'
  mode '0755'
  action :create
end
