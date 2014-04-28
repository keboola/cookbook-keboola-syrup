
include_recipe 'rsyslog'
include_recipe 'papertrail'

rsyslog_default_template = resources(:template => "/etc/rsyslog.d/50-default.conf")
rsyslog_default_template.cookbook "syrup"