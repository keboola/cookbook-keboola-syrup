
# start workers
$num = node['keboola-syrup']['gooddata-writer']['workers_count'].to_i

$i = 1
while $i <= $num  do
   execute "start queue worker N=#{$i}" do
	 command "start queue.queue-receive N=#{$i} QUEUE=gooddata-writer"
	 not_if "status queue.queue-receive N=#{$i} QUEUE=gooddata-writer"
   end
   $i +=1
end
