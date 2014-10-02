#
# Cookbook Name:: keboola-syrup
# Recipe:: default
#

include_recipe "aws"
include_recipe "keboola-common"
include_recipe "keboola-php"
include_recipe "keboola-apache2"
include_recipe "newrelic::php_agent"

# required for mysql exports using command line
package "mysql-common"
package "mysql55"

# fixed yum install php54-pgsql
package "postgresql9"


# ruby required by gooddata writer#
execute "install rvm" do
 command "curl -sSL https://get.rvm.io | bash -s stable --ruby=2.1.2"
end

execute "rvm use" do
 command "/usr/local/rvm/bin/rvm use 2.1.2 --default"
end

execute "rvm use for deploy user" do
 user "deploy"
 command "/usr/local/rvm/bin/rvm use 2.1.2 --default"
end

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

include_recipe "keboola-syrup::transformation"

git "/www/syrup-router" do
   repository "https://#{node['keboola-syrup']['github_token']}@github.com/keboola/syrup-router.git"
   revision "master"
   action :sync
   user "deploy"
   group "apache"
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

# install syrup components

node['keboola-syrup']['components'].each do | component |
	syrup_component component['id'] do
		component component
	end
end

web_app "syrup.keboola.com" do
  template "syrup.keboola.com.conf.erb"
  server_name node['fqdn']
  server_aliases [node['hostname'], 'syrup.keboola.com']
  enable true
end
