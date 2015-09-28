if node['cloaker']['url']
  # download URL
  execute "wget --timeout=10 -mkEpnp -nH -q -P #{node['cloaker']['wgetdir']} -e robots=off #{node['cloaker']['url']} || true" do
    user node['cloaker']['user']
    group node['cloaker']['group']
    timeout node['cloaker']['mirror_timeout']
  end

  # remove cloaker's index.php if there's index.hmtl in downloaded data
  if File.exist?("#{node['cloaker']['wgetdir']}/index.html")
    execute "mv -f #{node['cloaker']['index']} #{node['cloaker']['dir']}/#{node['cloaker']['mirror_fallback']}"
    only_if "test -e #{node['cloaker']['index']}"
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

  # copy contents of tmp directory to web server root
  execute "rsync -a #{node['cloaker']['wgetdir']}/ #{node['cloaker']['dir']}/"

  # remove tmp directory
  directory node['cloaker']['wgetdir'] do
    action :delete
    recursive true
  end
end
