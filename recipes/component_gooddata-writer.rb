package "php54-imap"


# cron records

action = node['keboola-syrup']['gooddata-writer']['enable_cron'].to_i > 0 ? :create : :delete

cron "gooddata writer clean" do
  user "deploy"
  hour "16"
  minute "54"
  command "/www/syrup-router/components/gooddata-writer/current/vendor/keboola/syrup/app/console gooddata-writer:clean-gooddata >/dev/null 2>&1"
  action action
end

cron "gooddata writer process-invitations" do
  user "deploy"
  minute "*/5"
  command "cd /www/syrup-router/components/gooddata-writer/current; php vendor/keboola/syrup/app/console gooddata-writer:process-invitations >/dev/null 2>&1"
  action action
end
