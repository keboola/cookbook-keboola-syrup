#
# Cookbook Name:: keboola-syrup
# Recipe:: default
#

include_recipe "aws"
include_recipe "keboola-common"
include_recipe "keboola-php55"
include_recipe "keboola-apache2"
include_recipe 'sysctl::apply'

if node['keboola-syrup']['enable_newrelic_apm'].to_i > 0
  include_recipe "newrelic::php_agent"
end

# required for mysql exports using command line
package "mysql-common"
package "mysql55"

# fixed yum install php54-pgsql
package "postgresql9"

aws_s3_file "/home/deploy/.ssh/bitbucket_id_rsa" do
  bucket "keboola-configs"
  remote_path "deploy-keys/bitbucket_id_rsa"
  aws_access_key_id node[:aws][:aws_access_key_id]
  aws_secret_access_key node[:aws][:aws_secret_access_key]
  owner "deploy"
  group "apache"
  mode "0600"
end

directory "/home/deploy/.aws" do
   owner 'deploy'
   group 'apache'
end

template "/home/deploy/.aws/credentials" do
  source 'aws-credentials.erb'
  owner 'deploy'
  group 'apache'
  mode "0600"
end

cookbook_file "/home/deploy/.ssh/config" do
  source "ssh_config_deploy"
  mode "0600"
  owner "deploy"
  group "apache"
end


execute "install composer" do
  command "curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer"
end


directory "/www" do
	user "deploy"
	group "apache"
	mode "0750"
end

git "/www/syrup-router" do
   repository "https://#{node['keboola-syrup']['github_token']}@github.com/keboola/syrup-router.git"
   revision "master"
   action :sync
   user "deploy"
   group "apache"
end

execute "configure composer" do
  user "deploy"
  group "apache"
  cwd "/www/syrup-router"
  environment(
    'COMPOSER_HOME' => '/home/deploy/.composer',
    'COMPOSER_CACHE_DIR' => '/home/deploy/.composer/cache'
  )
  command "/usr/local/bin/composer config -g github-oauth.github.com #{node['keboola-syrup']['github_token']}"
end

execute "install composer dependencies" do
  user "deploy"
  group "apache"
  cwd "/www/syrup-router"
  environment(
   'COMPOSER_HOME' => '/home/deploy/.composer',
   'COMPOSER_CACHE_DIR' => '/home/deploy/.composer/cache'
  )
  command "/usr/local/bin/composer install --no-dev --verbose --prefer-dist --optimize-autoloader --no-progress --no-interaction"
end

cron "graceful apache" do
  user "root"
  hour "17"
  minute "12"
  command "/etc/init.d/httpd graceful"
end

# install syrup components

node['keboola-syrup']['components'].each do | component |
  if node['keboola-syrup']['install-components'].empty? || node['keboola-syrup']['install-components'].index(component[:id])
    syrup_component component['id'] do
      component component
    end
  end
end

web_app "syrup.keboola.com" do
  template "syrup.keboola.com.conf.erb"
  server_name node['fqdn']
  server_aliases [node['hostname'], 'syrup.keboola.com']
  enable true
end
