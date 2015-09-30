#
if node['cloaker']['url']
  cloaker_dir = node['cloaker']['uri'].split('/')[0...-1].join('/')
  cloaker_dir = '/' if cloaker_dir === ''
  cloaker_fallback_dir = node['cloaker']['fallback_uri'].split('/')[0...-1].join('/')
  # absolute cloaker directory, e.g. /home/ec2-user/www/about
  cloaker_abs_dir = "#{['cloaker']['web_root']}/#{cloaker_dir}"
  cloaker_index = "#{['cloaker']['web_root']}/#{node['cloaker']['uri']}"
  cloaker_fallback_index = "#{['cloaker']['web_root']}/#{node['cloaker']['fallback_uri']}"
  cloaker_index_noext = cloaker_index.reverse().split('.')[0...-1].join('.').reverse()

  # remove tmp directory
  directory node['cloaker']['wgetdir'] do
    action :delete
    recursive true
  end

  # download URL
  execute "wget --timeout=#{node['cloaker']['wget_network_timeout']} -mkEpnp -nH -q -P #{node['cloaker']['wgetdir']} -e robots=off #{node['cloaker']['url']} || true" do
    user node['cloaker']['user']
    group node['cloaker']['group']
    timeout node['cloaker']['mirror_timeout']
  end

  # rename *.*.html files to *.html
  node['cloaker']['mirror_extensions'].each do |ext|
    execute "rename *.#{ext}.html files to *.html" do
      command <<-EOH
        for path in `find #{node['cloaker']['wgetdir']} -name '*.#{ext}.html'`; do
          newpath=`echo $path | sed -e 's/\\.#{ext}\\.html$/\\.html/'`
          mv $path $newpath
        done

        find #{node['cloaker']['wgetdir']} -type f -exec sed -i 's/\\.#{ext}\\.html/\\.html/' {} \\;
      EOH
    end
  end

  # check if downloaded data overlaps with cloaker fallback uri
  directory 'remove_overlapping_directory' do
    path "#{node['cloaker']['wgetdir']}/#{cloaker_fallback_dir}"
    action :nothing
    recursive true
  end

  # move cloaker's index.php to fallback_uri if there's index.html in downloaded data
  directory 'cloaker_fallback' do
    path "#{node['cloaker']['web_root']}/#{cloaker_fallback_dir}"
    owner node['cloaker']['user']
    group node['cloaker']['group']
    mode '0755'
    recursive true
    action :nothing
  end
  ruby_block "move cloaker to fallback path" do
    block do
      require 'fileutils'
      FileUtils.mv "#{cloaker_index}", "#{cloaker_fallback_index}"
    end
    notifies :create, 'directory[cloaker_fallback]', :immediately
    notifies :delete, 'directory[remove_overlapping_directory]', :immediately
    only_if { File.exist?(node['cloaker']['wgetdir']) and File.exist?(cloaker_index) }
  end

  # copy contents of tmp directory to web server root
  execute "rsync -a #{node['cloaker']['wgetdir']}/ #{node['cloaker']['web_root']}/"
end
