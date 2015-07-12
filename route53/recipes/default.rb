#
chef_gem 'aws-sdk' do
  compile_time false if respond_to?(:compile_time)
  action :install
end

ruby_block "create_hosted_zone" do
  block do
    chef_gem 'aws-sdk'
    require 'aws-sdk'

    # gather EC2 metadata
    ec2md = '/opt/aws/bin/ec2-metadata'
    public_ipv4 = `#{ec2md} -v`.split(' ')[1]

    # replace hostname's last dash with dot;
    # reverse server's hostname, then replace first dash, then reverse result again
    domain = node[:hostname].reverse.sub('-', '.').reverse

    # initialize Route53 connection; region isn't important
    route53 = Aws::Route53::Client.new(
      region: 'us-east-1',
      access_key_id: node[:route53][:access_key],
      secret_access_key: node[:route53][:secret_access_key]
    )

    # create Route53 hosted zone
    zone = route53.create_hosted_zone(name: domain)

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
    route53.change_resource_record_sets(
      hosted_zone_id: zone.hosted_zone.id,
      change_batch: {changes: [change1, change2]}
    )

  end
  action :run
end
