
default[:centrifuge][:pdo_url] = 'pgsql:host=localhost;dbname=rotator;port=5432;user=rotator'
default[:centrifuge][:log_path] = '/var/log/centrifuge/'
default[:centrifuge][:log_level] = 'INFO'
default[:centrifuge][:fallback_lander] = 1
default[:centrifuge][:click_method] = 'redirect'
default[:centrifuge][:click_url] = 'http://cpv.flagshippromotions.com/base2.php'
default[:centrifuge][:click_step_name] = 'id'
default[:centrifuge][:redis_url] = true
default[:segment][:write_key] = nil

default[:centrifuge][:mode] = 'production'
default[:centrifuge][:debug] = false

# Not used yet
default[:centrifuge][:content_repo] = 'centrifuge_landers'

default[:centrifuge][:cache] = {
  'expiration' => 3600,
  'adex_expiration' => 300,
  'root' => '/tmp/centrifuge/'
}

default[:centrifuge][:cookie_domain] = ''
default[:centrifuge][:hashids][:salt] = 'Quickpop sop. Flagship Salt.'

default[:aerospike][:host] = nil
default[:aerospike][:port] = nil
default[:aerospike][:namespace] = nil

# run setup
default['setup']['log'] = '/tmp/setup.log'
default['setup']['json'] = '/tmp/setup.json'
default['setup']['stage1'] = '/var/lib/aws/opsworks/client.stage1.rb'
default['setup']['stage2'] = '/var/lib/aws/opsworks/client.stage2.rb'
default['setup']['stage2_pid'] = '/var/lib/aws/opsworks/cache.stage2/chef-client-running.pid'
default['setup']['stage1_cmd'] = 'opsworks_custom_cookbooks::update,opsworks_custom_cookbooks::load,opsworks_custom_cookbooks::execute'
default['setup']['chef_client'] = '/opt/aws/opsworks/current/bin/chef-client'
default['setup']['access_key'] = nil
default['setup']['secret_key'] = nil
