default[:centrifuge][:ttl] = 3600
default[:centrifuge][:ae_ttl] = 300
default[:centrifuge][:env] = 'production'
default[:centrifuge][:pdo_url] = 'pgsql:host=localhost;dbname=rotator;port=5432;user=rotator'
default[:centrifuge][:log_path] = '/var/log/centrifuge/'
default[:centrifuge][:log_level] = 'Monolog\Logger::INFO'
default[:centrifuge][:fallback_lander] = 1
default[:centrifuge][:click_method] = 'redirect'
default[:centrifuge][:click_url] = 'http://cpv.flagshippromotions.com/base2.php'
default[:centrifuge][:enable_lander_tracking] = true
default[:centrifuge][:redis_url] = true
default[:segment][:write_key] = nil
