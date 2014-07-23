
default['keboola-syrup']['bitbucket_token'] = ''
default['keboola-syrup']['github_token'] = ''


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

# ruby is required by gooddata writer
default['rvm']['global_gems'] = [
  { 'name'    => 'bundler' }
]

default['rvm']['default_ruby'] = 'ruby-2.1.2'
