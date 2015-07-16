# add SSLMate repository
yum_repository 'sslmate' do
  description 'Zenoss Stable repo'
  baseurl 'http://packages.sslmate.com/centos/6/main/$basearch'
  gpgkey 'https://sslmate.com/yum/centos/RPM-GPG-KEY-SSLMate'
  action :create
end

# install SSLMate
yum_package 'sslmate' do
  action :install
  flush_cache [ :before ]
end

# configure aws credentials
directory '/root/.aws' do
  owner 'root'
  group 'root'
  mode '0700'
  action :create
end

template '/root/.aws/credentials' do
  source 'aws_credentials.erb'
  owner 'root'
  group 'root'
  action :create
  mode '0400'
end

# ensure ssl directory exists
directory "#{node[:sslmate][:ssldir]}" do
  mode '0770'
  owner 'root'
  group 'root'
  action :create
  recursive true
end

# replace hostname's last dash with dot;
# reverse server's hostname, then replace first dash, then reverse result again
domain = node[:hostname].reverse.sub('-', '.').reverse

# configure sslmate
template '/etc/sslmate.conf' do
  source 'sslmate.conf.erb'
  owner 'root'
  group 'root'
  mode '0640'
end

if node['route53']['hosted_zone_exists'] then
  # issue SSL cert
  execute 'buy_ssl_cert' do
    guard = <<-EOH
      sslmate list | grep #{domain}
    EOH

    user 'root'
    command <<-EOH
      sslmate --batch buy --temp --approval=dns #{domain}
    EOH
    not_if guard
  end

  # set up cron job to check for certificate readiness and download it when it's ready
  cron 'download_ssl_cert' do
    minute '*'
    user 'root'
    mailto 'root'
    home '/root'
    command <<-EOH
      /usr/bin/sslmate download #{domain} >/dev/null 2>&1; [ $? -eq 0 ] && /sbin/service nginx reload
    EOH
  end
else
  log 'message' do
    message "******Skipping certificate purchasing as Route53 Hosted Zone #{domain} doesn't exist******"
    level :warn
  end
end

# remove AWS credentials for security reasons
file '/root/.aws/credentials' do
  action :delete
end
