
# init job

template "/etc/init/queue.queue-receive.conf" do
  source 'queue.queue-receive.conf.erb'
  owner 'root'
  group 'root'
  mode 00644
end

# start workers

$i = 1
$num = node['keboola-syrup']['provisioning']['workers_count'].to_i

while $i <= $num  do
   execute "start provisioning queue worker N=#{$i}" do
	    command "start queue.queue-receive N=#{$i} QUEUE=provisioning"
	    not_if "status queue.queue-receive N=#{$i} QUEUE=provisioning"
   end
   $i +=1
end
