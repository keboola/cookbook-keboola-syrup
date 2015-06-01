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
