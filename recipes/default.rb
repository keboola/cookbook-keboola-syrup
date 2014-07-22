#
# Cookbook Name:: keboola-syrup
# Recipe:: default
#


include_recipe "aws"
include_recipe "keboola-syrup::php"
include_recipe "keboola-syrup::apache"
include_recipe "keboola-common"
include_recipe "newrelic::php-agent"

# required for mysql exports using command line
package "mysql-common"
package "mysql55"


aws_s3_file "/root/.ssh/kbc_id_rsa" do
  bucket "keboola-configs"
  remote_path "deploy-keys/kbc_id_rsa"
  aws_access_key_id node[:aws][:aws_access_key_id]
  aws_secret_access_key node[:aws][:aws_secret_access_key]
  owner "root"
  group "root"
  mode "0600"
end


cookbook_file "/root/.ssh/config" do
  source "ssh_config"
  mode "0600"
  owner "root"
  group "root"
end

cookbook_file "/home/deploy/.ssh/config" do
  source "ssh_config_deploy"
  mode "0600"
  owner "deploy"
  group "apache"
end


directory "/www/syrup-router" do
  owner "deploy"
  group "apache"
  mode 00755
  action :create
end


web_app "#{node['fqdn']}" do
  template "syrup.keboola.com.conf.erb"
  server_name node['fqdn']
  server_aliases [node['hostname'], 'syrup.keboola.com']
  enable true
end
