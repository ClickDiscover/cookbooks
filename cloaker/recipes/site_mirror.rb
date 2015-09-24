if node['cloaker']['url']
  # download URL
  execute "/usr/bin/wget --timeout=10 -mkEpnp -nH -q -P #{node['cloaker']['wgetdir']} -e robots=off #{node['cloaker']['url']}" do
    ignore_failure true
  end

  # rename index.php if it exists in the downloaded data
  if File.exist?("#{node['cloaker']['wgetdir']}/index.php")
    execute "/bin/mv #{node['cloaker']['wgetdir']}/index.php #{node['cloaker']['wgetdir']}/index.php.remote"
  end

  # copy contents of the tmp directory to web server root
  execute "/usr/bin/rsync #{node['cloaker']['wgetdir']}/ #{node['cloaker']['dir']}/"

  # remove the tmp directory
  directory "#{node['cloaker']['wgetdir']}" do
    action :delete
    recursive true
  end
end
