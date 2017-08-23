
# start workers

$i = 1
$num = node['keboola-syrup']['docker']['workers_count'].to_i

while $i <= $num  do
  execute "start docker queue worker N=#{$i}" do
    command "start queue.queue-receive N=#{$i} QUEUE=docker"
    not_if "status queue.queue-receive N=#{$i} QUEUE=docker"
  end
  $i +=1
end

if node['keboola-syrup']['docker']['install_docker'].to_i  > 0
  execute "start container stats collect" do
    command "start docker.collect-container-stats N=1"
    not_if "status docker.collect-container-stats N=1"
  end

  cron "docker runner garbage collect" do
    user "deploy"
    hour "15"
    minute "23"
    command "/www/syrup-router/components/docker/current/vendor/keboola/syrup/app/console docker:garbage-collect >/dev/null 2>&1"
    action action
  end

end



