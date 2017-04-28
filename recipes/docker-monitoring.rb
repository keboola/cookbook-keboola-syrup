execute "install newrelic key" do
  command "echo \"license_key: #{node['newrelic_infra']['license_key']}\" | tee -a /etc/newrelic-infra.yml"
end

execute "create newrelic repo" do
  command "sudo curl -o /etc/yum.repos.d/newrelic-infra.repo https://download.newrelic.com/infrastructure_agent/linux/yum/el/6/x86_64/newrelic-infra.repo"
end

execute "newrelic - Update your yum cache" do
  command "yum -q makecache -y --disablerepo='*' --enablerepo='newrelic-infra'"
end

execute "newrelic - install script" do
  command "sudo yum install newrelic-infra -y"
end