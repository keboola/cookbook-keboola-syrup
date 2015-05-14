
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
