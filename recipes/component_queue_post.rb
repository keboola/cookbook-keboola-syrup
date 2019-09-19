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
