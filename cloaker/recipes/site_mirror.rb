if node['cloaker']['url']
  # download URL
  execute "wget --timeout=10 -mkEpnp -nH -q -P #{node['cloaker']['wgetdir']} -e robots=off #{node['cloaker']['url']} || true" do
    user node['cloaker']['user']
    group node['cloaker']['group']
    timeout node['cloaker']['mirror_timeout']
  end

  # remove cloaker's index.php if there's index.html in downloaded data
  execute "mv -f #{node['cloaker']['index']} #{node['cloaker']['dir']}/#{node['cloaker']['mirror_fallback']}" do
    only_if "test -e #{node['cloaker']['wgetdir']}/index.html && test -e #{node['cloaker']['index']}"
  end

  # rename *.php.html files to *.html
  execute 'rename *.php.html files to *.html' do
    command <<-EOH
      for path in `find #{node['cloaker']['wgetdir']} -name '*.php.html'`; do
        newpath=`echo $path | sed -e 's/\.php\.html$/\.html/'`
        mv $path $newpath
      done
    EOH
  end

  # check if downloaded data overlaps with cloaker
  if node['cloaker']['cloaker_directory'] then
    execute "rm -rf #{node['cloaker']['wgetdir']}/#{node['cloaker']['cloaker_directory']}" do
      only_if "test -e #{node['cloaker']['wgetdir']}/#{node['cloaker']['cloaker_directory']}"
    end
  end
  if node['cloaker']['install_root'] then
    execute "rm -rf #{node['cloaker']['wgetdir']}/index.php" do
      only_if "test -e #{node['cloaker']['wgetdir']}/index.php"
    end
  end

  # copy contents of tmp directory to web server root
  execute "rsync -a #{node['cloaker']['wgetdir']}/ #{node['cloaker']['dir']}/"

  # remove tmp directory
  directory node['cloaker']['wgetdir'] do
    action :delete
    recursive true
  end
end
