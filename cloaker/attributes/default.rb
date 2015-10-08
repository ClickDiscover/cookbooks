# Blackjack settings
default['cloaker']['id'] = nil
default['cloaker']['uid'] = 'k65hjw6f2jivd063i6svww2f7'
default['cloaker']['name'] = nil
default['cloaker']['reinstall'] = false

# System settings
default['cloaker']['user'] = 'ec2-user'
default['cloaker']['group'] = 'ec2-user'
default['cloaker']['web_root'] = "/home/#{node['cloaker']['user']}/www"

# Mirror settings
default['cloaker']['url'] = nil
default['cloaker']['mirror_timeout'] = 1800
default['cloaker']['mirror_extensions'] = []

# HTTrack settings
default['cloaker']['httrack'] = {
  'max_bytes_sec' => 1000000000,
  'max_timeout' => 1200, # about 80% of mirror_timeout
  'link_timeout' => 10

}

# DEPRECATED: wget settings
default['cloaker']['wget_network_timeout'] = 10
default['cloaker']['wgetdir'] = '/tmp/site_mirror'

# Cloaker file settings
default['cloaker']['uri'] = '/index.php'
default['cloaker']['fallback_uri'] = '/about/index.php'
default['cloaker']['template'] = 'index.php.erb'
default['cloaker']['redirect_file'] = "#{node['cloaker']['web_root']}/external.php"
default['cloaker']['cloaked_url'] = nil
