
execute "install docker" do
  command "yum -y install docker-1.7.1-1.9.amzn1"
end

cookbook_file "/etc/sysconfig/docker" do
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

## Device mapper - steps from https://docs.docker.com/engine/userguide/storagedriver/device-mapper-driver/
execute "Create an LVM physical volume (PV)" do
  command "pvcreate #{node['keboola-syrup']['docker']['data_device']}"
end

execute "Create a new volume group (VG) " do
  command "vgcreate vg-docker  #{node['keboola-syrup']['docker']['data_device']}"
end

execute "Create a new 90GB logical volume (LV) called data " do
  command "lvcreate -L 90G -n data vg-docker"
end

execute "Create a new logical volume (LV) called metadata" do
  command "lvcreate -L 4G -n metadata vg-docker"
end

service "docker" do
  action :enable
end

service "docker" do
  action :start
end

execute "allow access to subnet NetHost_VPN_1a" do
  command "iptables -A FORWARD -d 10.0.222.0/24 -o eth0 -j ACCEPT"
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

if node['keboola-syrup']['enable_docker_monitoring'].to_i > 0
  include_recipe "keboola-syrup::docker-monitoring"
end


# init job
template "/etc/init/queue.queue-receive.conf" do
  source 'queue.queue-receive.conf.erb'
  owner 'root'
  group 'root'
  mode 00644
end
