
# install R
package "R"

# some R packages (such as devtools) require openssl-devel library be installed
execute "install openssl-devel" do
	command "yum -y install openssl-devel"
end

cookbook_file "/tmp/initR.R" do
	source "init_R_shiny"
	mode "0644"
  	owner "root"
  	group "root"
end	

execute "initialise R for shiny" do
  command "Rscript /tmp/initR.R --vanilla --quiet"
end

# get Shiny Server rpm
aws_s3_file "/tmp/shiny-server-commercial-1.3.0.540-rh6-x86_64.rpm" do
  bucket "keboola-configs"
  remote_path "syrup/shiny/shiny-server/shiny-server-commercial-1.3.0.540-rh6-x86_64.rpm"
  aws_access_key_id node[:aws][:aws_access_key_id]
  aws_secret_access_key node[:aws][:aws_secret_access_key]
end


execute "install shiny-server" do
  	command "yum -y --nogpgcheck install /tmp/shiny-server-commercial-1.3.0.540-rh6-x86_64.rpm"
end

# create shiny-server-config
cookbook_file "/etc/shiny-server/shiny-server.conf" do
  source "shiny_server_conf"
  mode "0644"
  owner "root"
  group "root"
end

# execute "create shiny admin user" do
#  command " echo 'somepassword' | /opt/shiny-server/bin/sspasswd /etc/shiny-server/passwd shiny-admin"
# end
