
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

template "/etc/init/queue.queue-container-stats-process.conf" do
  source 'queue.queue-container-stats-process.conf.erb'
  owner 'root'
  group 'root'
  mode 00644
end

template "/etc/init/queue.queue-storage-stats-process.conf" do
  source 'queue.queue-storage-stats-process.conf.erb'
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
