package "php56-mssql"

# create config for FreeTDS DB driver
cookbook_file "/etc/freetds.conf" do
  source "freetds_conf"
  mode "0644"
  owner "root"
  group "root"
end

# oracle

execute "download instantclient basic" do
  command "aws s3 cp s3://#{node['keboola-syrup']['configs-bucket']}/syrup/ex-db/oracle/oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm /tmp/oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm --region #{node['aws']['region']}"
  environment(
   'AWS_ACCESS_KEY_ID' => node['aws']['aws_access_key_id'],
   'AWS_SECRET_ACCESS_KEY' => node['aws']['aws_secret_access_key']
  )
end

execute "download instantclient devel" do
  command "aws s3 cp s3://#{node['keboola-syrup']['configs-bucket']}/syrup/ex-db/oracle/oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm /tmp/oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm --region #{node['aws']['region']}"
  environment(
   'AWS_ACCESS_KEY_ID' => node['aws']['aws_access_key_id'],
   'AWS_SECRET_ACCESS_KEY' => node['aws']['aws_secret_access_key']
  )
end

execute "install oracle instantclient" do
  command "yum -y --nogpgcheck install /tmp/oracle-instantclient*"
end

cookbook_file "/etc/profile.d/oracle.sh" do
  source "oracle.sh"
  mode "0644"
  owner "root"
  group "root"
end

php_pear 'oci8' do
  version '2.0.8'
  action 'install'
end
