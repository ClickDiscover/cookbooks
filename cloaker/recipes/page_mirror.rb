
if node['cloaker']['safe_page']
  cloaker_index = "#{node['cloaker']['web_root']}/#{node['cloaker']['uri']}"
  elems       = node['cloaker']['safe_page'].split('/')
  safe_domain = elems.take(3).join('/')
  safe_uri = elems.drop(3).join('/')

  if safe_uri.split('.').count > 1
    safe_dir = safe_uri.split('.')[0].split('/')[0...-1].join('/')
  else
    safe_dir = safe_uri
  end
  cloaker_uri = safe_dir + '/cl.php'
  external_uri = safe_dir + '/external.php'

  # remove tmp directory
  directory node['cloaker']['wgetdir'] do
    action :delete
    recursive true
  end

  # download URL
  wget_params = [
    "--quiet",
    "--page-requisites",
    # "--convert-links",
    # "--adjust-extension",
    # "--force-directories",
    "-E -H -k -K -p"
    "--timeout=#{node['cloaker']['wget_network_timeout']}",
    "-nH -P #{node['cloaker']['wgetdir']}",
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
  ruby_block "copy cloaker to fallback path" do
    block do
      require 'fileutils'
      FileUtils.cp "#{cloaker_index}", "#{node['cloaker']['web_root']}/#{cloaker_uri}"
      FileUtils.cp "#{node['cloaker']['redirect_file']}", "#{node['cloaker']['web_root']}/#{external_uri}"
    end
  end
end
