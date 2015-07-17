# don't proceed if id isn't set
return if not node['cloaker']['id']

# replace hostname's last dash with dot;
# reverse server's hostname, then replace first dash, then reverse result again
domain = node[:hostname].reverse.sub('-', '.').reverse

# set required parameters
id   = node['cloaker']['id']
host = node['cloaker']['gencloaker_host']
port = node['cloaker']['gencloaker_port']
name = if node['cloaker']['name'].present? then node['cloaker']['name'] else domain end

# download cloaker script
execute 'deploy-cloaker' do
  user 'ec2-user'
  group 'ec2-user'

  command <<-EOH
    /usr/bin/wget --timeout=10 -t 3 -O/home/ec2-user/www/index.php "http://#{host}:#{port}/cloaker?id=#{id}&name=#{name}"
  EOH
end
