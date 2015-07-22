
default['statsd']['backends'] = { 'statsd-librato-backend' => nil }

# Do we automatically delete idle stats?
default['statsd']['delete_idle_stats'] = false

# Is the graphite backend enabled?
default['statsd']['graphite_enabled'] = false
#
# Add any additional backend configuration here.
#
default['statsd']['extra_config'] = {
  'librato' => default['librato']
}
