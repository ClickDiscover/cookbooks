
include_recipe "statsd::install"

# configure the service
include_recipe "statsd::configure"
include_recipe "statsd::service"
