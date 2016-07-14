
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
end
