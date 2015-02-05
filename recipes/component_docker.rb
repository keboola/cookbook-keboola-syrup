package "docker"


cookbook_file "/etc/sudoers.d/docker" do
  source "docker_sudoers"
  mode "0600"
  owner "root"
  group "root"
end

# http://jpetazzo.github.io/2014/01/29/docker-device-mapper-resize/
directory "/var/lib/docker/devicemapper/devicemapper" do
  action :create
  owner "root"
  group "root"
end

link "/var/lib/docker/devicemapper/devicemapper" do
  to "#{node['keboola-syrup']['docker']['data_device']}"
  owner "root"
  group "root"
end

service "docker" do
  action :enable
end

service "docker" do
  action :start
end

# init job
template "/etc/init/queue.queue-receive.conf" do
  source 'queue.queue-receive.conf.erb'
  owner 'root'
  group 'root'
  mode 00644
end

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
