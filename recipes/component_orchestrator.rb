
# scheduler
action = node['keboola-syrup']['orchestrator']['enable_scheduler'].to_i > 0 ? :create : :delete

cron "orchestrator scheduler" do
  user "deploy"
  minute "*"
  command "php /www/syrup-router/components/orchestrator/current/vendor/keboola/syrup/app/console orchestrator:scheduler > /dev/null 2>&1 "
  action action
end

# workers

$i = 1
$num = node['keboola-syrup']['orchestrator']['workers_count'].to_i

while $i <= $num  do
   cron "orchestrator worker #{$i}" do
     user "deploy"
     minute "*"
     command "php /www/syrup-router/components/orchestrator/current/vendor/keboola/syrup/app/console orchestrator:queue > /dev/null 2>&1"
     action "create"
   end
   $i +=1
end