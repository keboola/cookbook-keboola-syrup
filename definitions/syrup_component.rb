

define :syrup_component do

	componentName = params[:name]
	componentBasePath = "/www/syrup-router/components/#{componentName}"

	directory componentBasePath do
	  owner "deploy"
	  group "apache"
	  mode 0755
	  action :create
	end

	directory "#{componentBasePath}/releases" do
	  owner "deploy"
	  group "apache"
	  mode 0755
	  action :create
	end

	directory "#{componentBasePath}/shared" do
	  owner "deploy"
	  group "apache"
	  mode 0755
	  action :create
	end

	time = Time.now.to_i

	node.set['keboola-syrup'][componentName]['current-release-path'] = "#{componentBasePath}/releases/#{time}"

	if params[:component][:source] && params[:component][:source] == 'github'
		git "#{componentBasePath}/releases/#{time}" do
		   repository "https://#{node['keboola-syrup']['github_token']}@github.com/keboola/#{params[:component][:repository_name]}.git"
		   revision "production"
		   action :sync
		   user "deploy"
		   group "apache"
		end
	else
		git "#{componentBasePath}/releases/#{time}" do
		   repository "git@bitbucket.org:keboola/#{params[:component][:repository_name]}.git"
		   revision "production"
		   action :sync
		   user "deploy"
		   group "apache"
		end
	end


	aws_s3_file "#{componentBasePath}/shared/parameters.yml" do
	  bucket node['keboola-syrup']['configs-bucket']
	  remote_path "syrup/#{componentName}/parameters.yml"
	  aws_access_key_id node[:aws][:aws_access_key_id]
	  aws_secret_access_key node[:aws][:aws_secret_access_key]
	  owner "deploy"
	  group "apache"
	  mode "0644"
	end

	execute "copy parameters.yml" do
	  command "cp #{componentBasePath}/shared/parameters.yml #{componentBasePath}/releases/#{time}/parameters.yml"
	  user "deploy"
	end

	if params[:component][:has_recipe]
	  include_recipe "keboola-syrup::component_#{componentName}"
	end

	execute "install composer dependencies" do
	  user "deploy"
	  group "apache"
	  cwd "#{componentBasePath}/releases/#{time}"
	  environment(
	   	'HOME' => '/home/deploy',
       'COMPOSER_HOME' => '/home/deploy/.composer',
       'COMPOSER_CACHE_DIR' => '/home/deploy/.composer/cache',
			 'AWS_REGION' => node['keboola-syrup']['region'],
			 'KEBOOLA_SYRUP_CONFIGS_BUCKET' => node['keboola-syrup']['configs-bucket']
      )
	  command "/usr/local/bin/composer install --no-dev --verbose --prefer-dist --optimize-autoloader --no-progress --no-interaction"
	end

	if params[:component][:bundle_install]
		include_recipe "keboola-syrup::ruby"
		execute "install bundler dependencies" do
		  cwd "#{componentBasePath}/releases/#{time}"
		  user "deploy"
		  group "apache"
		  command "export PATH=/usr/local/rvm/gems/ruby-2.1.2/bin:/usr/local/rvm/gems/ruby-2.1.2@global/bin:/usr/local/rvm/rubies/ruby-2.1.2/bin:$PATH && bundle install --gemfile ./Gemfile --path ../../shared/bundle --deployment --quiet --without development test"
		end
	end

	directory "#{componentBasePath}/releases/#{time}/vendor/keboola/syrup/app/cache" do
		owner "deploy"
        group "apache"
        mode 00775
	end

	directory "#{componentBasePath}/releases/#{time}/vendor/keboola/syrup/app/logs" do
		owner "deploy"
		group "apache"
		mode 00775
	end

	execute "create revision file" do
	  cwd "#{componentBasePath}/releases/#{time}"
	  command "git rev-parse HEAD > REVISION"
	  user "deploy"
      group "apache"
	end

	execute "create version file" do
	  cwd "#{componentBasePath}/releases/#{time}"
	  command "git describe --tags > VERSION"
	  user "deploy"
      group "apache"
	end


	link "#{componentBasePath}/current" do
	  to "#{componentBasePath}/releases/#{time}"
	  owner "deploy"
	  group "apache"
	end

	# in post recipe should be only execution of workers started
	if params[:component][:has_post_recipe]
		include_recipe "keboola-syrup::component_#{componentName}_post"
	end

end
