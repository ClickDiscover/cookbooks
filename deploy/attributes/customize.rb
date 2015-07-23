default[:opsworks][:deploy_user][:user] = 'ec2-user'
default[:opsworks][:deploy_user][:group] = 'ec2-user'

node[:deploy].each do |application, deploy|
  default[:deploy][application][:deploy_to] = "/home/ec2-user/#{application}"
end
