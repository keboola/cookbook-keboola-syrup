

cltool_path = Chef::Config[:file_cache_path] + "/cl-tool-1.2.73.tar.gz"

remote_file cltool_path do
  source "https://github.com/gooddata/GoodData-CL/archive/1.2.73.tar.gz"
  mode "0644"
end

directory "/www/gooddata-cli-current"  do
  owner "deploy"
  group "apache"
  mode "0755"
  action :create
  recursive true
end

execute "untar-cl-tool" do
  cwd "/www/gooddata-cli-current"
  command "tar --strip-components 1 -xzf " + cltool_path
end