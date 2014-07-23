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


# required by gooddata writer#
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

aws_s3_file "/root/.ssh/kbc_id_rsa" do
  bucket "keboola-configs"
  remote_path "deploy-keys/kbc_id_rsa"
  aws_access_key_id node[:aws][:aws_access_key_id]
  aws_secret_access_key node[:aws][:aws_secret_access_key]
  owner "root"
  group "root"
  mode "0600"
end

execute "install composer" do
  command "curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer"
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

git "/www/syrup-router" do
   repository "https://#{node['keboola-syrup']['github_token']}@github.com/keboola/syrup-router.git"
   revision "master"
   action :sync
   user "deploy"
   group "apache"
end


directory "/www/syrup-router/components/gooddata-writer" do
  owner "deploy"
  group "apache"
  mode 0755
  action :create
end

directory "/www/syrup-router/components/gooddata-writer/releases" do
  owner "deploy"
  group "apache"
  mode 0755
  action :create
end

directory "/www/syrup-router/components/gooddata-writer/shared" do
  owner "deploy"
  group "apache"
  mode 0755
  action :create
end

time = Time.now.to_i

git "/www/syrup-router/components/gooddata-writer/releases/#{time}" do
   repository "https://#{node['keboola-syrup']['bitbucket_token']}@bitbucket.org/keboola/gooddata-writer.git"
   revision "master"
   action :sync
   user "deploy"
   group "apache"
end


aws_s3_file "/www/syrup-router/components/gooddata-writer/shared/parameters.yml" do
  bucket "keboola-configs"
  remote_path "syrup/gooddata-writer/parameters.yml"
  aws_access_key_id node[:aws][:aws_access_key_id]
  aws_secret_access_key node[:aws][:aws_secret_access_key]
  owner "deploy"
  group "apache"
  mode "0555"
end

execute "copy parameters.yml" do
  command "cp /www/syrup-router/components/gooddata-writer/shared/parameters.yml /www/syrup-router/components/gooddata-writer/releases/#{time}/parameters.yml"
  user "deploy"
end

execute "install compopser dependencies" do
  cwd "/www/syrup-router/components/gooddata-writer/releases/#{time}"
  command "/usr/local/bin/composer install --no-dev --verbose --prefer-dist --optimize-autoloader --no-progress --no-interaction"
end

execute "install bundler dependencies" do
  cwd "/www/syrup-router/components/gooddata-writer/releases/#{time}"
  user "deploy"
  command "/usr/local/rvm/gems/ruby-2.1.2@global/bin/bundle install --gemfile ./Gemfile --path ../../shared/bundle --deployment --quiet --without development test"
end

execute "create revision file" do
  cwd "/www/syrup-router/components/gooddata-writer/releases/#{time}"
  command "git rev-parse HEAD > REVISION"
end

execute "create version file" do
  cwd "/www/syrup-router/components/gooddata-writer/releases/#{time}"
  command "git describe --tags > VERSION"
end

link "/www/syrup-router/components/gooddata-writer/current" do
  to "/www/syrup-router/components/gooddata-writer/releases/#{time}"
  owner "deploy"
  group "apache"
end

web_app "#{node['fqdn']}" do
  template "syrup.keboola.com.conf.erb"
  server_name node['fqdn']
  server_aliases [node['hostname'], 'syrup.keboola.com']
  enable true
end
