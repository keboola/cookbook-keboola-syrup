package "php56-mssql"

# create config for FreeTDS DB driver
cookbook_file "/etc/freetds.conf" do
  source "freetds_conf"
  mode "0644"
  owner "root"
  group "root"
end

# oracle
aws_s3_file "/tmp/oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm" do
  bucket "keboola-configs"
  remote_path "syrup/ex-db/oracle/oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm"
  aws_access_key_id node[:aws][:aws_access_key_id]
  aws_secret_access_key node[:aws][:aws_secret_access_key]
end

aws_s3_file "/tmp/oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm" do
  bucket "keboola-configs"
  remote_path "syrup/ex-db/oracle/oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm"
  aws_access_key_id node[:aws][:aws_access_key_id]
  aws_secret_access_key node[:aws][:aws_secret_access_key]
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

php_pear 'oci8-2.0.8' do
  action 'install'
end
