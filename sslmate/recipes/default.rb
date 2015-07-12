# add SSLMate repository
yum_repository 'sslmate' do
  description 'Zenoss Stable repo'
  baseurl 'http://packages.sslmate.com/centos/$releasever/main/$basearch'
  gpgkey 'https://sslmate.com/yum/centos/RPM-GPG-KEY-SSLMate'
  action :create
end

# install SSLMate
yum_package 'sslmate' do
  action :install
  flush_cache [ :before ]
end

# replace hostname's last dash with dot;
# reverse server's hostname, then replace first dash, then reverse result again
domain = node[:hostname].reverse.sub('-', '.').reverse

# configure sslmate
template '/etc/sslmate.conf' do
  force_unlink true
  source 'sslmate.conf.erb'
  owner 'root'
  group 'root'
  mode '0640'
end

# issue SSL cert
execute 'buy_ssl_cert' do
  guard = <<-EOH
    sslmate list | grep #{domain}
  EOH

  user 'root'
  command <<-EOH
    sslmate --batch buy --temp --email=admin@#{domain} #{domain}
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
