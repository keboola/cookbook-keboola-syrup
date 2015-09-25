
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

# odbc driver
aws_s3_file "/etc/snowflake_linux_x8664_odbc.tgz" do
  bucket "keboola-configs"
  remote_path "syrup/transformation/snowflake/snowflake_linux_x8664_odbc.tgz"
  aws_access_key_id node[:aws][:aws_access_key_id]
  aws_secret_access_key node[:aws][:aws_secret_access_key]
end

execute "unpack snowflake driver" do
  command "cd /etc && tar xvfz /etc/snowflake_linux_x8664_odbc.tgz"
end

execute "install snowflake driver" do
  command "cd /etc/snowflake_odbc && ./unixodbc_setup.sh"
end

cookbook_file "/etc/odbcinst.ini" do
  source "odbcinst.ini"
  mode "0644"
  owner "root"
  group "root"
end

cookbook_file "/etc/snowflake_odbc/conf/unixodbc.snowflake.ini" do
  source "unixodbc.snowflake.ini"
  mode "06444"
  owner "root"
  group "root"
end

execute "append SIMBAINI variable to profile" do
  command "echo \"export SIMBAINI=/etc/snowflake_odbc/conf/unixodbc.snowflake.ini\" >> /etc/profile"
end

execute "increase php memory limit" do 
  command "sed -i -- 's/memory_limit = 128M/memory_limit = 256M/g' /etc/php.ini"
end

# start workers

$i = 1
$num = node['keboola-syrup']['transformation']['workers_count'].to_i

while $i <= $num  do
   execute "start tapi queue worker N=#{$i}" do
	 command "start queue.queue-receive N=#{$i} QUEUE=tapi"
	 not_if "status queue.queue-receive N=#{$i} QUEUE=tapi"
   end
   $i +=1
end