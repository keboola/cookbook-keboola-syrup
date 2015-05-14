
# init job

template "/etc/init/queue.queue-receive.conf" do
  source 'queue.queue-receive.conf.erb'
  owner 'root'
  group 'root'
  mode 00644
end

template "/etc/init/queue.queue-receive-kill.conf" do
  source 'queue.queue-receive-kill.conf.erb'
  owner 'root'
  group 'root'
  mode 00644
end

cookbook_file "/etc/sudoers.d/kill" do
  source "queue_kill_sudoers"
  mode "0600"
  owner "root"
  group "root"
end

# start workers

# run kill queue on all servers
execute "start queue kill queue" do
  command "start queue.queue-receive-kill"
  not_if "status queue.queue-receive-kill"
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
