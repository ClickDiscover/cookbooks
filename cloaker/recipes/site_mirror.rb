if node['cloaker']['url']
  # preserve index.php before data removal
  if File.exist?("#{node['cloaker']['index']}")
    execute "mv #{node['cloaker']['index']} /tmp/index.php"
  end

  # recreate cloaker directory
  directory node['cloaker']['dir'] do
    action :delete
    recursive true
  end
  directory node['cloaker']['dir'] do
    owner node['cloaker']['user']
    group node['cloaker']['group']
    mode '0755'
    action :create
    recursive true
  end
  execute "mv /tmp/index.php #{node['cloaker']['index']}"

  # download URL
  execute "wget --timeout=10 -mkEpnp -nH -q -P #{node['cloaker']['wgetdir']} -e robots=off #{node['cloaker']['url']} || /bin/true" do
    user node['cloaker']['user']
    group node['cloaker']['group']
  end

  # rename index.php if it exists in downloaded data
  if File.exist?("#{node['cloaker']['wgetdir']}/index.php")
    execute "mv #{node['cloaker']['wgetdir']}/index.php #{node['cloaker']['wgetdir']}/#{node['cloaker']['mirror_fallback']}"
  end

  # rename *.php.html files to *.html
  execute 'rename *.php.html files to *.html' do
    command <<-EOH
      for path in `find #{node['cloaker']['wgetdir']} -name '*.php.html'`; do
        newpath=`echo $path | sed -e 's/\.php\.html$/\.html/'`
        mv #{node['cloaker']['wgetdir']}/$path #{node['cloaker']['wgetdir']}/$newpath
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
