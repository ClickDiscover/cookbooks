default['cloaker']['id'] = nil
default['cloaker']['uid'] = 'k65hjw6f2jivd063i6svww2f7'
default['cloaker']['name'] = nil
default['cloaker']['url'] = nil
default['cloaker']['user'] = 'ec2-user'
default['cloaker']['group'] = 'ec2-user'
default['cloaker']['dir'] = "/home/#{node['cloaker']['user']}/www"
default['cloaker']['index'] = "#{node['cloaker']['dir']}/index.php"
default['cloaker']['install_root'] = true
default['cloaker']['cloaker_directory'] = 'about'
default['cloaker']['wgetdir'] = '/tmp/site_mirror'
default['cloaker']['reinstall'] = false
default['cloaker']['mirror_timeout'] = 18000
default['cloaker']['mirror_fallback'] = 'about.php'
default['cloaker']['mirror_extensions'] = ['php', 'asp', 'jsp']
default['cloaker']['wget_network_timeout'] = 10
