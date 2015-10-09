
if node['cloaker']['safe_page']
  cloaker_index = "#{node['cloaker']['web_root']}/#{node['cloaker']['uri']}"
  elems       = node['cloaker']['safe_page'].split('/')
  safe_domain = elems.take(3).join('/')
  safe_uri = elems.drop(3).join('/')

  modified_uri = "/#{node['cloaker']['uri_prefix']}/#{safe_uri}"
  if modified_uri.split('.').count > 1
    modified_uri = modified_uri.split('.')[0] + '.php'
  else
    modified_uri = modified_uri + '/index.php'
  end
  modified_dir = modified_uri.split('/')[0...-1].join('/')

  # remove tmp directory
  directory node['cloaker']['wgetdir'] do
    action :delete
    recursive true
  end

  # download URL
  wget_params = [
    "--quiet",
    "--page-requisites",
    "--convert-links",
    "--adjust-extension",
    "--force-directories",
    "--timeout=#{node['cloaker']['wget_network_timeout']}",
    "-P #{node['cloaker']['wgetdir']}",
    node['cloaker']['safe_page']
  ].join(' ')

  execute "wget #{wget_params}" do
    user node['cloaker']['user']
    group node['cloaker']['group']
    timeout node['cloaker']['mirror_timeout']
  end

  # copy contents of tmp directory to web server root
  execute "rsync -a #{node['cloaker']['wgetdir']}/ #{node['cloaker']['web_root']}/"

  # prepare fallback directory
  directory 'modified_directory' do
    path "#{node['cloaker']['web_root']}/#{modified_dir}"
    owner node['cloaker']['user']
    group node['cloaker']['group']
    mode '0755'
    recursive true
    action :create
  end

  ruby_block "copy cloaker to fallback path" do
    block do
      require 'fileutils'
      FileUtils.cp "#{cloaker_index}", "#{modified_uri}"
    end
  end
end
