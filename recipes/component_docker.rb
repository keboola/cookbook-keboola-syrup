package "docker"

cookbook_file "/etc/default/docker" do
  source "docker_defaults"
  mode "0600"
  owner "root"
  group "root"
end

cookbook_file "/etc/sudoers.d/docker" do
  source "docker_sudoers"
  mode "0600"
  owner "root"
  group "root"
end

# http://jpetazzo.github.io/2014/01/29/docker-device-mapper-resize/
directory "/var/lib/docker/devicemapper/devicemapper" do
  action :create
  recursive true
  owner "root"
  group "root"
end

# put dosker device mapper to EBS in RAID
link "/var/lib/docker/devicemapper/devicemapper/data" do
  to "#{node['keboola-syrup']['docker']['data_device']}"
  owner "root"
  group "root"
end

service "docker" do
  action :enable
end

service "docker" do
  action :start, :immediately
end

execute "reject connections to local subnets" do
  command "iptables -A FORWARD -d 10.0.0.0/8 -o eth0 -j REJECT --reject-with icmp-port-unreachable"
end

execute "docker iptables - 1" do
  command "iptables -A FORWARD -o docker0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT"
end

execute "docker iptables - 2" do
  command "iptables -A FORWARD -i docker0 ! -o docker0 -j ACCEPT"
end

execute "docker iptables - 3" do
  command "iptables -A FORWARD -i docker0 -o docker0 -j ACCEPT"
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
