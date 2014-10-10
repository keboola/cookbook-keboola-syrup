directory "/www/transformation" do
  owner "deploy"
  group "apache"
  mode 00755
  action :create
end

directory "/www/transformation/releases" do
  owner "deploy"
  group "apache"
  mode 0755
  action :create
end

directory "/www/transformation/shared" do
  owner "deploy"
  group "apache"
  mode 00755
  action :create
end

directory "/www/transformation/shared/application/configs" do
  owner "deploy"
  group "apache"
  recursive true
  mode 00555
  action :create
end

aws_s3_file "/www/transformation/shared/application/configs/config.ini" do
  bucket "keboola-configs"
  remote_path "transformation/config.ini"
  aws_access_key_id node[:aws][:aws_access_key_id]
  aws_secret_access_key node[:aws][:aws_secret_access_key]
  owner "deploy"
  group "apache"
  mode "0555"
end

time = Time.now.to_i

git "/www/transformation/releases/#{time}" do
   repository "https://#{node['keboola-syrup']['github_token']}@github.com/keboola/transformation-api.git"
   revision "production"
   action :sync
   user "deploy"
   group "apache"
end


execute "create revision file" do
  cwd "/www/transformation/releases/#{time}"
  command "git rev-parse HEAD > REVISION"
  user "deploy"
  group "apache"
end

execute "chown-data-www" do
  command "chown -R deploy:apache /www/transformation/releases/#{time}"
  action :run
end

directory "/www/transformation/releases/#{time}/cache" do
	mode "0775"
end

execute "install composer dependencies" do
  user "deploy"
  group "apache"
  cwd "/www/transformation/releases/#{time}"
  environment(
   'COMPOSER_HOME' => '/home/deploy/.composer',
   'COMPOSER_CACHE_DIR' => '/home/deploy/.composer/cache'
  )
  command "/usr/local/bin/composer install --no-dev --verbose --prefer-dist --optimize-autoloader --no-progress --no-interaction"
end

link "/www/transformation/releases/#{time}/application/configs/config.ini" do
  to "/www/transformation/shared/application/configs/config.ini"
  user "deploy"
  group "apache"
end




link "/www/transformation/current" do
  to "/www/transformation/releases/#{time}"
  owner "deploy"
  group "apache"
end

link "/www/transformation/latest" do
  to "/www/transformation/releases/#{time}"
  owner "deploy"
  group "apache"
end


web_app "transformation.keboola.com" do
  template "transformation.keboola.com.conf.erb"
  server_name 'transformation.keboola.com'
  server_aliases ["#{node.name}-transformation.keboola.com"]
  enable true
end

web_app "transformation-test.keboola.com" do
  template "transformation-test.keboola.com.conf.erb"
  server_name 'transformation-test.keboola.com'
  server_aliases ["#{node.name}-transformation-test.keboola.com"]
  enable true
end

