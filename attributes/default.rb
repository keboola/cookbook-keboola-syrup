
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
		id: "rt-json",
		repository_name: "jsonparser-bundle"
	},
	{
		id: "rt-hierarchy",
		repository_name: "hierarchy-bundle"
	},
	{
		id: "restbox",
		repository_name: "restbox-bundle"
	},
	{
		id: "provisioning",
		repository_name: "keboola-provisioning-bundle"
	},
	{
		id: "ex-zendesk",
		repository_name: "zendesk-extractor-bundle"
	},
	{
		id: "ex-telfa",
		repository_name: "telfa-extractor-bundle"
	},
	{
		id: "ex-recurly",
		repository_name: "recurly-bundle"
	},
	{
		id: "ex-pingdom",
		repository_name: "keboola-pingdom-bundle"
	},
	{
		id: "ex-ooyala",
		repository_name: "ooyala-extractor-bundle"
	},
	{
		id: "ex-marketo",
		repository_name: "marketo-extractor-bundle",
		has_recipe: true
	},
	{
		id: "ex-instagram",
		repository_name: "instagram-extractor-bundle"
	},
	{
		id: "ex-google-youtube",
		repository_name: "google-youtube-bundle"
	},
	{
		id: "ex-elasticsearch",
		repository_name: "elasticsearch-extractor-bundle"
	},
	{
		id: "ex-db",
		repository_name: "db-extractor-bundle"
	},
	{
		id: "ex-currency",
		repository_name: "currency-bundle"
	},
	{
		id: "ex-cloudsearch",
		repository_name: "cloudsearch-extractor"
	},
	{
		id: "ex-mailchimp",
		repository_name: "mailchimp-extractor-bundle"
	},
	{
		id: "ex-doubleclick",
		repository_name: "doubleclick-extractor-bundle"
	},
	{
		id: "sapi-importer",
		repository_name: "sapi-importer-bundle"
	},
	{
		id: "wr-elasticsearch",
		repository_name: "elasticsearch-writer-bundle"
	},
	{
		id: "wr-db",
		repository_name: "db-writer-bundle"
	},
	{
		id: "wr-cloudsearch",
		repository_name: "cloudsearch-writer"
	},
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
	},
	{
		id: "orchestrator",
		repository_name: "orchestrator-bundle",
		bundle_install: false
	},
	{
		id: "ex-gooddata",
		repository_name: "gooddata-extractor-bundle",
		bundle_install: false
	}
]

default['keboola-syrup']['components-broken'] = [
	{
		id: "rt-lucky-guess",
		repository_name: "luckyguess-bundle",
		bundle_install: false
	},
	{
		id: "ex-google-analytics",
		repository_name: "google-analytics-bundle"
	}
]


