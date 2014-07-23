
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


default['nodejs']['install_method'] = 'binary'
default['nodejs']['version'] = '0.10.26'
default['nodejs']['checksum_linux_x64'] = '305bf2983c65edea6dd2c9f3669b956251af03523d31cf0a0471504fd5920aac'
default['nodejs']['checksum_linux_x86'] = '8fa2d952556c8b5aa37c077e2735c972c522510facaa4df76d4244be88f4dc0f'
default['nodejs']['checksum_linux_arm-pi'] = '561ec2ebfe963be8d6129f82a7d1bc112fb8fbfc0a1323ebe38ef55850f25517'
default['nodejs']['dir'] = '/usr'

default['newrelic']['php-agent']['config_file'] = "/etc/php.d/newrelic.ini"
