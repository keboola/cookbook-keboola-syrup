
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
  notifies :restart, 'service[rsyslog]', :immediately
end

cookbook_file "/etc/sudoers.d/kill" do
  source "queue_kill_sudoers"
  mode "0600"
  owner "root"
  group "root"
end

# start workers


$num = node['keboola-syrup']['queue']['workers_count'].to_i

if $num > 0 then
  execute "start queue kill queue" do
    command "start queue.queue-receive-kill N=1"
    not_if "status queue.queue-receive-kill N=1"
  end
end

$i = 1
while $i <= $num  do
   execute "start queue worker N=#{$i}" do
	 command "start queue.queue-receive N=#{$i} QUEUE=default"
	 not_if "status queue.queue-receive N=#{$i} QUEUE=default"
   end
   $i +=1
end
