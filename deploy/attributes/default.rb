
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

default['deploy']['json'] = '/tmp/deploy.json'
default['deploy']['setup_log'] = '/tmp/deploy_setup.log'
default['deploy']['chef_client'] = '/opt/aws/opsworks/current/bin/chef-client'
# update custom cookbooks
default['deploy']['stage1'] = '/var/lib/aws/opsworks/client.stage1.rb'
default['deploy']['stage1_cmd'] = 'opsworks_custom_cookbooks::update,opsworks_custom_cookbooks::load,opsworks_custom_cookbooks::execute'
# setup
default['deploy']['stage2'] = '/var/lib/aws/opsworks/client.stage2.rb'
default['deploy']['stage2_cmd'] = 'nginx,php-fpm,collectd,nginx::collectd,statsd,php-fpm::collectd,php-fpm::aerospike'
