

version = node['keboola-syrup']['gooddata-writer']['cl_tool_version']
cltool_path = Chef::Config[:file_cache_path] + "/cl-tool-#{version}.tar.gz"

remote_file cltool_path do
  source "https://github.com/gooddata/GoodData-CL/archive/#{version}.tar.gz"
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

# init job

template "/etc/init/gooddata-writer.queue-receive.conf" do
  source 'gooddata-writer.queue-receive.conf.erb'
  owner 'root'
  group 'root'
  mode 00644
end


# cron records

action = node['keboola-syrup']['gooddata-writer']['enable_cron'].to_i > 0 ? :create : :delete

cron "gooddata writer clean" do
  user "deploy"
  hour "16"
  minute "54"
  command "/www/syrup-router/components/gooddata-writer/current/vendor/keboola/syrup/app/console gooddata-writer:clean-gooddata >/dev/null 2>&1"
  action action
end

cron "gooddata writer accept-invitations" do
  user "deploy"
  minute "*/5"
  command "cd /www/syrup-router/components/gooddata-writer/current; php vendor/keboola/syrup/app/console gooddata-writer:accept-invitations >/dev/null 2>&1"
  action action
end


# start workers

$i = 1
$num = node['keboola-syrup']['gooddata-writer']['workers_count'].to_i

while $i <= $num  do
   execute "start gooddata writer worker N=#{$i}" do
	 command "start gooddata-writer.queue-receive N=#{$i}"
	 not_if "status gooddata-writer.queue-receive N=#{$i}"
   end
   $i +=1
end
