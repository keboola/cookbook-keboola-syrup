
# start workers

$i = 1
$num = node['keboola-syrup']['transformation']['workers_count'].to_i

while $i <= $num  do
   execute "start tapi queue worker N=#{$i}" do
	    command "start queue.queue-receive N=#{$i} QUEUE=tapi"
	    not_if "status queue.queue-receive N=#{$i} QUEUE=tapi"
   end
   $i +=1
end
