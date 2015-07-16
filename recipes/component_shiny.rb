
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

execute "download shiny server" do
  command "curl https://s3.amazonaws.com/rstudio-shiny-server-pro-build/centos-5.9/x86_64/shiny-server-commercial-1.3.0.540-rh5-x86_64.rpm > /tmp/shiny.rpm"
end

execute "symlink libssl" do
  command "ln -f -s /usr/lib64/libssl.so.10 /usr/lib64/libssl.so.6"
end

execute "symlink libcrypto" do
	command "ln -f -s /usr/lib64/libcrypto.so /usr/lib64/libcrypto.so.6"
end

execute "install shiny-server" do
  	command "yum -y --nogpgcheck install /tmp/shiny.rpm"
end

# create shiny-server-config
cookbook_file "/etc/shiny-server/shiny-server.conf" do
  source "shiny_server_conf"
  mode "0644"
  owner "root"
  group "root"
end

# allow writing to the R/library directory for package installations
execute "library permissions" do
	command "chmod -R 0777 /usr/lib64/R/library"
end

# execute "create shiny admin user" do
#  command " echo 'somepassword' | /opt/shiny-server/bin/sspasswd /etc/shiny-server/passwd shiny-admin"
# end
