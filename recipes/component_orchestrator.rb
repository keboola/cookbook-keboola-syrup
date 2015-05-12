
# scheduler
action = node['keboola-syrup']['orchestrator']['enable_scheduler'].to_i > 0 ? :create : :delete

cron "orchestrator scheduler" do
  user "deploy"
  minute "*"
  command "php /www/syrup-router/components/orchestrator/current/vendor/keboola/syrup/app/console orchestrator:scheduler 2>&1 | /usr/bin/logger -t 'cron_scheduler' -p local1.info"
  action action
end

# watchdog
action = node['keboola-syrup']['orchestrator']['enable_watchdog'].to_i > 0 ? :create : :delete

cron "orchestrator watchdog" do
  user "deploy"
  minute "*/10"
  command "php /www/syrup-router/components/orchestrator/current/vendor/keboola/syrup/app/console orchestrator:cron:watchdog 2>&1 | /usr/bin/logger -t 'cron_watchdog' -p local1.info"
  action action
end

# workers

$i = 1
$num = node['keboola-syrup']['orchestrator']['workers_count'].to_i

while $i <= $num  do
  execute "start orchestrator worker N=#{$i}" do
    command "start queue.queue-receive N=#{$i} QUEUE=orchestrator"
    not_if "status queue.queue-receive N=#{$i} QUEUE=orchestrator"
  end
  $i +=1
end
