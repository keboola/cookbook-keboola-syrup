
default['aws']['aws_access_key_id'] = ''
default['aws']['aws_secret_access_key'] = ''

default['postfix']['main']['smtp_sasl_password_maps'] = 'static:'
default['postfix']['main']['transport_maps'] = nil


default['apache']['user'] = 'apache'
default['apache']['package'] = 'httpd24'
default['apache']['default_modules'] = %w[
  logio auth_basic authn_file authz_groupfile authz_host authz_user
  dir env mime negotiation setenvif
]

default['php']['packages'] = %w{ php54 php54-devel php-pear php54-pdo php54-mysqlnd php54-pgsql php54-mcrypt php54-pecl-apc }


default['newrelic']['php-agent']['config_file'] = "/etc/php.d/newrelic.ini"


default['keboola-syrup']['github_token'] = ''

default['keboola-syrup']['gooddata']['cl_tool_version'] = '1.2.73'

default['keboola-syrup']['components'] = [
	{
		id: "gooddata-writer",
		repository_name: "gooddata-writer",
		bundle_install: true,
		has_recipe: true
	},
	{
		id: "ex-google-drive",
		repository_name: "google-drive-bundle",
        bundle_install: false
	},
	{
		id: "queue",
		repository_name: "syrup-queue-bundle",
		bundle_install: false
	}
]


