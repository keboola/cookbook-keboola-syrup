

action = node['syrup']['cron_gooddata_writer_enabled'].to_i > 0 ? :create : :delete

cron "gooddata_writer_queue" do
  user "apache"
  command "php /www/syrup-router/components/gooddata-writer/current/vendor/keboola/syrup/app/console gooddata-writer:queue:receive >/dev/null 2>&1"
  action action
end

cron "gooddata_writer_clean" do
  user "apache"
  minute "54"
  hour "16"
  command "php /www/syrup-router/components/gooddata-writer/current/vendor/keboola/syrup/app/console gooddata-writer:clean-gooddata >/dev/null 2>&1"
  action action
end