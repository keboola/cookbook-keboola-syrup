
# install mssql php extension
package "php54-mssql"

# create config for FreeTDS DB driver
cookbook_file "/etc/freetds.conf" do
  source "freetds_conf"
  mode "0644"
  owner "root"
  group "root"
end

