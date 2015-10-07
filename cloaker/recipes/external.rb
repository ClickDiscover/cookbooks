
# Redirct to cloaked url
if node['cloaker']['cloaked_url']
  template node['cloaker']['redirect_file'] do
    source 'external.php.erb'
    owner node['cloaker']['user']
    group node['cloaker']['group']
    mode '0644'
  end
end
