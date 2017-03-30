# datadog agent

execute "run docker agent" do
  command "docker run -d --name dd-agent -e DD_HOSTNAME=`hostname` -v /var/run/docker.sock:/var/run/docker.sock:ro -v /proc/:/host/proc/:ro -v /cgroup/:/host/sys/fs/cgroup:ro -e API_KEY=#{node['datadog']['api_key']} -e SD_BACKEND=docker datadog/docker-dd-agent:latest"
end