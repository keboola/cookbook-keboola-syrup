

directory "/home/#{node['current_user']}/.aws" do
  owner 'root'
  group 'root'
end

template "/home/#{node['current_user']}/.aws/config" do
  source 'aws.config.erb'
  owner 'root'
  group 'root'
  mode 0600
end