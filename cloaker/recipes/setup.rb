# install httrack
httrack_file_name = node['cloaker']['httrack']['package'].split('/')[-1]

remote_file "/tmp/#{httrack_file_name}" do
  source node['cloaker']['httrack']['package']
  action :create
end

package 'httrack' do
  source "/tmp/#{httrack_file_name}"
end

# ensure rsync is instaled
package 'rsync'

# ensure /home/ec2-user directory exists and has correct permissions
directory '/home/ec2-user' do
  mode '0755'
  owner 'ec2-user'
  group 'ec2-user'
  action :create
end

# ensure cloaker directory exists
directory node['cloaker']['web_root'] do
  owner node['cloaker']['user']
  group node['cloaker']['group']
  mode '0755'
  action :create
  recursive true
end
