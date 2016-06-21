
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

aws_s3_file "/tmp/snowflake_linux_x8664_odbc.tgz" do
  bucket "keboola-configs"
  remote_path "drivers/snowflake/snowflake_linux_x8664_odbc.2.12.73.tgz"
  aws_access_key_id node[:aws][:aws_access_key_id]
  aws_secret_access_key node[:aws][:aws_secret_access_key]
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

cookbook_file "/etc/simba.snowflake.ini" do
  source "simba.snowflake.ini"
  mode "0644"
  owner "root"
  group "root"
end

execute "append SIMBAINI variable to profile" do
  command "echo \"export SIMBAINI=/etc/simba.snowflake.ini\" >> /etc/profile"
end

execute "append LD_LIBRARY_PATH variable to profile" do
  command "echo \"export LD_LIBRARY_PATH=/usr/bin/snowflake_odbc/lib\" >> /etc/profile"
end

execute "append SSL_DIR variable to profile" do
  command "echo \"export SSL_DIR=/usr/bin/snowflake_odbc/SSLCertificates/nssdb\" >> /etc/profile"
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
