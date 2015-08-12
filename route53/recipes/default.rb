#
require 'aws-sdk'

public_ipv4 = node[:opsworks][:instance][:ip]

# replace hostname's last dash with dot;
# reverse server's hostname, then replace first dash, then reverse result again
domain = node[:hostname].reverse.sub('-', '.').reverse

# initialize Route53 connection; region isn't important
route53 = AWS::Route53::Client.new(
  region: 'us-east-1',
  access_key_id: node[:route53][:access_key],
  secret_access_key: node[:route53][:secret_access_key]
)

##########################################################
# Automatic Route53 Hosted Zone creation disabled for now
##########################################################
# stop if zone already exists
# return if hosted_zones.include?(domain)
#
# create Route53 hosted zone
# zone = route53.create_hosted_zone(name: domain, caller_reference: public_ipv4)
##########################################################
#
zone = nil
# get list of hosted zones
marker = nil
while true
  # The maximum number of hosted zones returned by R53 API is 100
  if marker
    resp = route53.list_hosted_zones({marker: marker})
  else
    resp = route53.list_hosted_zones
  end

  resp.hosted_zones.each{ |hz|
    # ignore trailing dot
    puts hz.name[0...-1]
    puts hz.name.class
    if hz.name[0...-1] === domain
      zone = hz
    end
  }
  # stop is there are no more pages
  break if !resp.is_truncated
  marker = resp.next_marker
end

# don't proceed if there's no hosted zone for configured domain
if not zone then
  log 'message' do
    message "******Skipping Route53 Hosted Zone record creation: Zone #{domain} doesn't exist******"
    level :info
  end
  node.set['route53']['hosted_zone_exists'] = false
  return
end

node.set['route53']['hosted_zone_exists'] = true

# setup @ record
change1 = { 
  action: 'CREATE',
  resource_record_set: {
    name: domain,
    type: 'A',
    ttl: 300,
    resource_records: [{value: public_ipv4}]
  }
}

# setup www record
change2 = { 
  action: 'CREATE',
  resource_record_set: {
    name: "www.#{domain}",
    type: 'CNAME',
    ttl: 300,
    resource_records: [{value: domain}]
  }
}

# create @ and www records
begin
  route53.change_resource_record_sets(
    hosted_zone_id: zone.id,
    change_batch: {changes: [change1, change2]}
  )
rescue AWS::Route53::Errors::InvalidChangeBatch
  log 'message' do
    message "******Skipping Route53 Hosted Zone record creation: it seems the required records are already in place******"
    level :warn
  end
end
