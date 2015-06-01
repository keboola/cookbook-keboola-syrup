
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


web_app "json-parser.keboola.com" do
  template "json-parser.keboola.com.conf.erb"
  server_name node['json-parser.keboola.com']
  server_aliases []
  enable true
end
