yum_package "docker =  1.7.1-1.9.amzn1"

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
  action :start
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


# datadog agent
execute "install datadog agent" do
  command "DD_API_KEY=#{node['datadog']['api_key']} bash -c \"$(curl -L https://raw.githubusercontent.com/DataDog/dd-agent/master/packaging/datadog-agent/source/install_agent.sh)\""
end

execute "modify datadog agent" do
  command "dd-agent stop"
  command "usermod -a -G docker dd-agent"
  command "cp /etc/dd-agent/conf.d/docker_daemon.yaml.example /etc/dd-agent/conf.d/docker_daemon.yaml"
  command "/etc/init.d/datadog-agent restart"
end

# docker agent
execute "pull docker agent" do
  command "docker pull datadog/docker-dd-agent:latest"
end

execute "run docker agent" do
  command "docker run -d --name dd-agent -h `hostname` -v /var/run/docker.sock:/var/run/docker.sock -v /proc/:/host/proc/:ro -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro -e API_KEY=#{node['datadog']['api_key']} datadog/docker-dd-agent:latest"
end

# init job
template "/etc/init/queue.queue-receive.conf" do
  source 'queue.queue-receive.conf.erb'
  owner 'root'
  group 'root'
  mode 00644
end
