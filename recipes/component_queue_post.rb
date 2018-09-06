# start workers

# run kill queue on all servers
execute "start queue kill queue" do
  command "start queue.queue-receive-kill N=1"
  not_if "status queue.queue-receive-kill N=1"
end

$num = node['keboola-syrup']['queue']['workers_count'].to_i

$i = 1
while $i <= $num  do
   execute "start queue worker N=#{$i}" do
	    command "start queue.queue-receive N=#{$i} QUEUE=default"
	    not_if "status queue.queue-receive N=#{$i} QUEUE=default"
   end
   $i +=1
end

# container stats
$num = node['keboola-syrup']['queue']['containers_stats_workers_count'].to_i
$i = 1
while $i <= $num  do
    execute "start container stats queue worker N=#{$i}" do
        command "start queue.queue-container-stats-process N=#{$i} QUEUE=container-stats"
        not_if "status queue.queue-container-stats-process N=#{$i} QUEUE=container-stats"
    end
    $i +=1
end

# storage stats
$num = node['keboola-syrup']['queue']['storage_stats_workers_count'].to_i
$i = 1
while $i <= $num  do
    execute "start storage stats queue worker N=#{$i}" do
        command "start queue.queue-storage-stats-process N=#{$i} QUEUE=storage-stats"
        not_if "status queue.queue-storage-stats-process N=#{$i} QUEUE=storage-stats"
    end
    $i +=1
end

# elastic stats
$num = node['keboola-syrup']['queue']['elastic_stats_workers_count'].to_i
$i = 1
while $i <= $num  do
    execute "start elastic stats queue worker N=#{$i}" do
        command "start queue.queue-elastic-stats-process N=#{$i}"
        not_if "status queue.queue-elastic-stats-process N=#{$i}"
    end
    $i +=1
end

cron "queue snapshot elastic" do
    user "deploy"
    hour "21,09"
    minute "23"
    command "/www/syrup-router/components/queue/current/vendor/keboola/syrup/app/console syrup:queue:elastic-snapshot 2>&1 | /usr/bin/logger -t 'cron_elastic_snapshot' -p local1.info"
    action action
end
