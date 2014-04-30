#
# Cookbook Name:: syrup
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME


# All rights reserved - Do Not Redistribute#

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


include_recipe "aws"
include_recipe "hostname"
include_recipe "keboola-syrup::logging"


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
  server_aliases [node['hostname']]
  enable true
end
