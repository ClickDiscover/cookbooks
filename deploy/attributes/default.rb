
default[:centrifuge][:pdo_url] = 'pgsql:host=localhost;dbname=rotator;port=5432;user=rotator'
default[:centrifuge][:log_path] = '/var/log/centrifuge/'
default[:centrifuge][:log_level] = 'INFO'
default[:centrifuge][:fallback_lander] = 1
default[:centrifuge][:click_method] = 'redirect'
default[:centrifuge][:click_url] = 'http://cpv.flagshippromotions.com/base2.php'
default[:centrifuge][:redis_url] = true
default[:segment][:write_key] = nil

default[:centrifuge][:mode] = 'development'
default[:centrifuge][:debug] = true

# Not used yet
default[:centrifuge][:content_repo] = 'centrifuge_landers'

default[:centrifuge][:cache] = {
  'expiration' => 3600,
  'adex_expiration' => 300,
  'root' => '/tmp/centrifuge/'
}

default[:centrifuge][:cookie_domain] = ''
default[:centrifuge][:hashids][:salt] = 'Quickpop sop. Flagship Salt.'
