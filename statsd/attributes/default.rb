
default['statsd']['backends'] = { 'statsd-librato-backend' => nil }

# Do we automatically delete idle stats?
default['statsd']['delete_idle_stats'] = true

# Is the graphite backend enabled?
default['statsd']['graphite_enabled'] = false
#
# Add any additional backend configuration here.
#


# source = [node['librato']['environment'], node['hostname']].compact.join('.')
default['statsd']['extra_config'] = {
  'librato' => {
    'email' => node['librato']['email'],
    'token' => node['librato']['api_key'],
    'includeMetrics' => ['/centrifuge/', '/keyword/', '/lander/'],
    'sourceRegex' => '/^([^\-]+)\-/'
  }
}

default['statsd']['repo'] = 'https://github.com/etsy/statsd.git'
default['statsd']['version'] = 'v0.7.2'
default['statsd']['log_file'] = '/var/log/statsd.log'
default['statsd']['config_dir'] = '/etc/statsd'
default['statsd']['pid_dir'] = '/var/run/statsd'
default['statsd']['pid_file'] = '/var/run/statsd/statsd.pid'
default['statsd']['path'] = '/usr/share/statsd'
default['statsd']['user'] = 'statsd'
default['statsd']['group'] = 'statsd'
default['statsd']['flush_interval_msecs'] = 10_000
default['statsd']['port'] = 8125

# Enable console output
default['statsd']['console_enabled'] = false

default['statsd']['service'] = {
  enable: true,
  start: true
}

