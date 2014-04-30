default['aws']['aws_access_key_id'] = ''
default['aws']['aws_secret_access_key'] = ''

default['apache']['user'] = 'apache'
default['apache']['package'] = 'httpd24'
default['apache']['default_modules'] = %w[
  status alias auth_basic authn_file authz_groupfile authz_host authz_user autoindex
  dir env mime negotiation setenvif mpm_event
]

default['papertrail']['remote_port'] = 49730
default['set_fqdn'] = "*.keboola.com"