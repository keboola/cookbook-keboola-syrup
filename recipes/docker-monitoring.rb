# datadog agent
execute "install datadog agent" do
  command "DD_API_KEY=#{node['datadog']['api_key']} bash -c \"$(curl -L https://raw.githubusercontent.com/DataDog/dd-agent/master/packaging/datadog-agent/source/install_agent.sh)\""
end

execute "stop datadog agent" do
  command "dd-agent stop"
end

execute "modify datadog agent group" do
  command "usermod -a -G docker dd-agent"
end

execute "enable datadog config template" do
  command "cp /etc/dd-agent/conf.d/docker_daemon.yaml.example /etc/dd-agent/conf.d/docker_daemon.yaml"
end
  
execute "start datadog agent" do
  command "/etc/init.d/datadog-agent restart"
end

# docker agent
execute "pull docker agent" do
  command "docker pull datadog/docker-dd-agent:latest"
end

execute "run docker agent" do
  command "docker run -d --name dd-agent -h `hostname` -v /var/run/docker.sock:/var/run/docker.sock -v /proc/:/host/proc/:ro -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro -e API_KEY=#{node['datadog']['api_key']} datadog/docker-dd-agent:latest"
end