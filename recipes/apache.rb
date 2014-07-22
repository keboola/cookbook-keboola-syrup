
file "#{node['apache']['dir']}/conf.d/autoindex.conf" do
  action :delete
  backup false
end

include_recipe "apache2"



unless node['apache']['listen_ports'].include?('443')
  node.set['apache']['listen_ports'] = node['apache']['listen_ports'] + ['443']
end

if platform_family?('rhel', 'fedora', 'suse')
  package 'mod24_ssl' do
    notifies :run, 'execute[generate-module-list]', :immediately
  end

  file "#{node['apache']['dir']}/conf.d/ssl.conf" do
    action :delete
    backup false
  end
end

template 'ssl_ports.conf' do
  path      "#{node['apache']['dir']}/ports.conf"
  source    'ports.conf.erb'
  mode      '0644'
  cookbook  'apache2'
  notifies  :restart, 'service[apache2]'
end

apache_module 'ssl' do
  conf true
end

apache_module 'alias' do
  conf true
end

apache_default_template = resources(:template => "apache2.conf")
apache_default_template.cookbook "keboola-syrup"

apache_sysconfig_template = resources(:template => "/etc/sysconfig/httpd")
apache_sysconfig_template.cookbook "keboola-syrup"

aws_s3_file "/tmp/ssl-keboola.com.tar.gz" do
  bucket "keboola-configs"
  remote_path "certificates/ssl-keboola.com.tar.gz"
  aws_access_key_id node[:aws][:aws_access_key_id]
  aws_secret_access_key node[:aws][:aws_secret_access_key]
end

directory "#{node['apache']['dir']}/ssl" do
  owner "root"
  group "root"
  mode 00644
  action :create
end

execute "extract-certificates" do
  command "tar --strip 1 -C #{node['apache']['dir']}/ssl -xf  /tmp/ssl-keboola.com.tar.gz"
end


directory "/www" do
  owner "root"
  group "root"
  mode 0555
  action :create
end
