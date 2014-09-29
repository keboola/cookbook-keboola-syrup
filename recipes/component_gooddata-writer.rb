

version = node['keboola-syrup']['gooddata-writer']['cl_tool_version']
cltool_path = Chef::Config[:file_cache_path] + "/cl-tool-#{version}.tar.gz"

remote_file cltool_path do
  source "https://s3.amazonaws.com/gooddata-cl/gooddata-cli-#{version}.tar.gz"
  mode "0644"
end

directory "/www/gooddata-cli-#{version}"  do
  owner "deploy"
  group "apache"
  mode "0755"
  action :create
  recursive true
end

execute "untar-cl-tool" do
  cwd "/www/gooddata-cli-#{version}"
  command "tar --strip-components 2 -xzf " + cltool_path
end

link "/www/gooddata-cli-current" do
  to "/www/gooddata-cli-#{version}"
  owner "deploy"
  group "apache"
end

# init job

template "/etc/init/gooddata-writer.queue-receive.conf" do
  source 'gooddata-writer.queue-receive.conf.erb'
  owner 'root'
  group 'root'
  mode 00644
end

# SSO
aws_s3_file "/tmp/gnupg.tgz" do
  bucket "keboola-configs"
  remote_path "syrup/gooddata-writer/gnupg.tgz"
  aws_access_key_id node[:aws][:aws_access_key_id]
  aws_secret_access_key node[:aws][:aws_secret_access_key]
end

execute "extract-gpg-keys" do
  command "tar -C /root -zxvf /tmp/gnupg.tgz"
end

cookbook_file "/etc/sudoers.d/gooddata_writer_sso" do
  source "gooddata_writer_sso_sudoers"
  mode "0600"
  owner "root"
  group "root"
end

currentReleasePath = node['keboola-syrup']['gooddata-writer']['current-release-path']

puts 'current release path'
puts currentReleasePath

execute "copy sso script" do
  command "cp #{currentReleasePath}/GoodData/gooddata-sso.sh /usr/local/bin/gooddata-sso.sh"
  user "root"
end

file "/usr/local/bin/gooddata-sso.sh" do
  action :touch
  owner 'root'
  group 'root'
  mode '0750'
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
