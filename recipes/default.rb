#
# Cookbook Name:: keboola-syrup
# Recipe:: default
#

include_recipe "aws"
include_recipe "keboola-common"
include_recipe "keboola-php56"
include_recipe "keboola-apache2"
include_recipe 'sysctl::apply'

# apache homedir fix - gpg requires apache homedir
directory '/var/www' do
  owner 'apache'
  group 'apache'
end

if node['keboola-syrup']['enable_newrelic_apm'].to_i > 0
  include_recipe "newrelic::php_agent"
end

# required for mysql exports using command line
package "mysql-common"
package "mysql55"

# limits
set_limit '*' do
  type 'hard'
  item 'nofile'
  value 50000
  use_system true
end

set_limit '*' do
  type 'soft'
  item 'nofile'
  value 50000
  use_system true
end

set_limit 'root' do
  type 'hard'
  item 'nofile'
  value 50000
  use_system true
end

set_limit 'root' do
  type 'soft'
  item 'nofile'
  value 50000
  use_system true
end

execute "download bitbucket key" do
  command "aws s3 cp s3://#{node['keboola-syrup']['configs-bucket']}/deploy-keys/bitbucket_2_id_rsa /home/deploy/.ssh/bitbucket_id_rsa --region #{node['aws']['region']}"
  environment(
    'AWS_ACCESS_KEY_ID' => node['aws']['aws_access_key_id'],
    'AWS_SECRET_ACCESS_KEY' => node['aws']['aws_secret_access_key']
  )
end

file "/home/deploy/.ssh/bitbucket_id_rsa" do
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

execute "append REGION variable to profile" do
  command "echo \"export AWS_REGION=#{node['keboola-syrup']['region']}\" >> /etc/profile.d/keboola.sh"
end

execute "append KEBOOLA_SYRUP_CONFIGS_BUCKET variable to profile" do
  command "echo \"export KEBOOLA_SYRUP_CONFIGS_BUCKET=#{node['keboola-syrup']['configs-bucket']}\" >> /etc/profile.d/keboola.sh"
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
