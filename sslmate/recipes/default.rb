# replace dash in fqdn to get domain name to work with
hostname = node[:hostname].gsub('-', '.')

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
    sslmate list | grep #{hostname}
  EOH

  user 'root'
  command <<-EOH
    sslmate --batch buy --temp --email=admin@#{hostname} #{hostname}
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
    /usr/bin/sslmate download #{hostname}; [ $? -eq 0 ] && /sbin/service nginx reload
  EOH
end
