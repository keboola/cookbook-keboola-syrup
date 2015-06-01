
directory "/www/jsonparser-api" do
  owner "deploy"
  group "apache"
  mode 0755
  action :create
end

git "/www/jsonparser-api" do
   repository "https://#{node['keboola-syrup']['github_token']}@github.com/keboola/jsonparser-api.git"
   revision "master"
   action :sync
   user "deploy"
   group "apache"
end

execute "install composer dependencies" do
  user "deploy"
  group "apache"
  cwd "/www/jsonparser-api"
  environment(
   'HOME' => '/home/deploy',
     'COMPOSER_HOME' => '/home/deploy/.composer',
     'COMPOSER_CACHE_DIR' => '/home/deploy/.composer/cache'
    )
  command "/usr/local/bin/composer install --verbose --prefer-dist --optimize-autoloader --no-progress --no-interaction"
end

directory "/www/jsonparser-api/app/cache" do
  owner "deploy"
  group "apache"
  mode 00775
end

directory "/www/jsonparser-api/app/logs" do
  owner "deploy"
  group "apache"
  mode 00775
end

file "/www/jsonparser-api/symfony-jsonparser.log" do
  owner 'root'
  group 'apache'
  mode '0755'
  action :touch
end

web_app "zz_json-parser.keboola.com" do
  template "json-parser.keboola.com.conf.erb"
  server_name 'json-parser.keboola.com'
  server_aliases []
  enable true
end
