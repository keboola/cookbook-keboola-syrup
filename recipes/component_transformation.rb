
# init job

template "/etc/init/queue.queue-receive.conf" do
  source 'queue.queue-receive.conf.erb'
  owner 'root'
  group 'root'
  mode 00644
end

#odbc support for php 5.6
execute "install unixodbc" do
  command "yum -y install unixODBC.x86_64"
end

execute "install php56-odbc" do
  command "yum -y install php56-odbc php56-odbc.x86_64"
end

execute "download snowflake drivers" do
  command "aws s3 cp s3://#{node['keboola-syrup']['configs-bucket']}/drivers/snowflake/snowflake_linux_x8664_odbc-2.16.6.tgz /tmp/snowflake_linux_x8664_odbc.tgz --region #{node['aws']['region']}"
  environment(
   'AWS_ACCESS_KEY_ID' => node['aws']['aws_access_key_id'],
   'AWS_SECRET_ACCESS_KEY' => node['aws']['aws_secret_access_key']
  )
end


execute "unpack snowflake driver" do
  command "gunzip /tmp/snowflake_linux_x8664_odbc.tgz"
end

execute "untar snowflake driver" do
  command "cd /tmp && tar -xvf snowflake_linux_x8664_odbc.tar"
end

execute "move snowflake driver" do
  command "mv /tmp/snowflake_odbc /usr/bin/snowflake_odbc"
end

cookbook_file "/etc/odbcinst.ini" do
  source "odbcinst.ini"
  mode "0644"
  owner "root"
  group "root"
end

cookbook_file "/usr/bin/snowflake_odbc/lib/simba.snowflake.ini" do
  source "simba.snowflake.ini"
  mode "0644"
  owner "root"
  group "root"
end


