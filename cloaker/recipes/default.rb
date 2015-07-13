# replace hostname's last dash with dot;
# reverse server's hostname, then replace first dash, then reverse result again
domain = node[:hostname].reverse.sub('-', '.').reverse

# ensure /home/ec2-user/www directory exists
directory '/home/ec2-user/www' do
  owner 'ec2-user'
  group 'ec2-user'
  mode '0755'
  action :create
end

# download cloaker script
execute 'deploy-cloaker' do
  id   = node['cloaker']['id']
  host = node['cloaker']['gencloaker_host']
  port = node['cloaker']['gencloaker_port']
  name = if node['cloaker']['name'].present? then node['cloaker']['name'] else domain end

  command <<-EOH
    curl http://#{host}:#{port}/cloaker?id=#{id}&name=#{name} > /home/ec2-user/www/index.php
  EOH
end
