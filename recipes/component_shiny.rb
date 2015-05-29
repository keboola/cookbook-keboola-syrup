
# install R
package "R"

# get Shiny Server rpm
aws_s3_file "/tmp/shiny-server-commercial-1.3.0.540-rh6-x86_64.rpm" do
  bucket "keboola-configs"
  remote_path "syrup/shiny/shiny-server-commercial-1.3.0.540-rh6-x86_64.rpm"
  aws_access_key_id node[:aws][:aws_access_key_id]
  aws_secret_access_key node[:aws][:aws_secret_access_key]
end

# create shiny-server-config
cookbook_file "/etc/shiny-server/shiny-server.conf" do
  source "shiny_server_conf"
  mode "0644"
  owner "root"
  group "root"
end

execute "install shiny R package" do
  command "R -e \"install.packages('shiny', repos='http://cran.rstudio.com/')\""
end

execute "install shiny-server" do
  	command "yum -y --nogpgcheck install /tmp/shiny-server-commercial-1.3.0.540-rh6-x86_64.rpm"
end

# execute "create shiny admin user" do
#  command " echo 'somepassword' | /opt/shiny-server/bin/sspasswd /etc/shiny-server/passwd shiny-admin"
# end
