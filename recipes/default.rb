#
# Cookbook Name:: keboola-syrup
# Recipe:: default
#

user "deploy" do
  gid "apache"
  home "/home/deploy"
  shell "/bin/bash"
end

remote_file "/home/ec2-user/.ssh/authorized_keys" do
	source "https://s3.amazonaws.com/keboola-configs/servers/devel_ssh_public_keys.txt"
  only_if { File.directory?("/home/ec2-user") }
end

directory "/home/deploy/.ssh" do
  owner "deploy"
  group "apache"
  mode 0700
  action :create
end

remote_file "/home/deploy/.ssh/authorized_keys" do
  owner "deploy"
  group "apache"
  mode 0700
  source "https://s3.amazonaws.com/keboola-configs/servers/devel_ssh_public_keys.txt"
end

file "#{node['apache']['dir']}/conf.d/autoindex.conf" do
  action :delete
  backup false
end

include_recipe "aws"
include_recipe "hostname"
include_recipe "keboola-syrup::logging"
include_recipe "php"
include_recipe "apache2"

unless node['apache']['listen_ports'].include?('443')
  node.set['apache']['listen_ports'] = node['apache']['listen_ports'] + ['443']
end

if platform_family?('rhel', 'fedora', 'suse')
  package 'mod24_ssl' do
    notifies :run, 'execute[generate-module-list]', :immediately
  end

  file "#{node['apache']['dir']}/conf.d/ssl.conf" do
    action :delete
    backup false
  end
end

template 'ssl_ports.conf' do
  path      "#{node['apache']['dir']}/ports.conf"
  source    'ports.conf.erb'
  mode      '0644'
  cookbook  'apache2'
  notifies  :restart, 'service[apache2]'
end

apache_module 'ssl' do
  conf true
end

apache_default_template = resources(:template => "apache2.conf")
apache_default_template.cookbook "keboola-syrup"

aws_s3_file "/tmp/ssl-keboola.com.tar.gz" do
  bucket "keboola-configs"
  remote_path "certificates/ssl-keboola.com.tar.gz"
  aws_access_key_id node[:aws][:aws_access_key_id]
  aws_secret_access_key node[:aws][:aws_secret_access_key]
end

directory "#{node['apache']['dir']}/ssl" do
  owner "root"
  group "root"
  mode 00644
  action :create
end

execute "extract-certificates" do
  command "tar --strip 1 -C #{node['apache']['dir']}/ssl -xf  /tmp/ssl-keboola.com.tar.gz"
end


package 'php55-opcache'
package 'php55-pdo'
package 'php55-mcrypt'
package 'php55-mysqlnd'
package 'php55-pgsql'

template "#{node['php']['ext_conf_dir']}/opcache.ini" do
  source 'opcache.ini.erb'
  owner 'root'
  group 'root'
  mode 00644
  if node['recipes'].include?('php::fpm')
    notifies :restart, "service[#{svc}]"
  end
end

directory "/www" do
  owner "root"
  group "root"
  mode 0555
  action :create
end

directory "/www/syrup-router" do
  owner "root"
  group "root"
  mode 00555
  action :create
end

aws_s3_file "/tmp/syrup.latest.tar.gz" do
  bucket "syrup-releases"
  remote_path "syrup.latest.tar.gz"
  aws_access_key_id node[:aws][:aws_access_key_id]
  aws_secret_access_key node[:aws][:aws_secret_access_key]
end

execute "extract-syrup" do
  command "tar --strip 1 -C /www/syrup-router -xf  /tmp/syrup.latest.tar.gz"
end

web_app "#{node['fqdn']}" do
  template "syrup.conf.erb"
  server_name node['fqdn']
  server_aliases [node['hostname'], 'syrup.keboola.com']
  enable true
end

