# replace hostname's last dash with dot;
# reverse server's hostname, then replace first dash, then reverse result again
domain = node[:hostname].reverse.sub('-', '.').reverse

execute 'deploy-cloaker' do
  id   = node['cloaker']['id']
  host = node['cloaker']['gencloaker_host']
  port = node['cloaker']['gencloaker_port']
  name = if node['cloaker']['name'].present? then node['cloaker']['name'] else domain end

  command <<-EOH
    curl http://#{host}:#{port}/cloaker?id=#{id}&name=#{name} > /home/ec2-user/www/index.php
  EOH
end
