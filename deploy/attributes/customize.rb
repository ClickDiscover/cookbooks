normal[:opsworks][:deploy_user][:user] = 'ec2-user'
normal[:opsworks][:deploy_user][:group] = 'ec2-user'
normal['deploy']['stage2_cmd'] = 'opsworks_rubygems,nginx,php-fpm,collectd,nginx::collectd,statsd,php-fpm::collectd,php-fpm::aerospike'
