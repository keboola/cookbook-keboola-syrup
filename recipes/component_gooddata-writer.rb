package "php56-imap"

# init job


# SSO
aws_s3_file "/tmp/gnupg.tgz" do
  bucket "keboola-configs"
  remote_path "syrup/gooddata-writer/gnupg-2015.tar.gz"
  aws_access_key_id node[:aws][:aws_access_key_id]
  aws_secret_access_key node[:aws][:aws_secret_access_key]
end

execute "extract-gpg-keys" do
  command "tar -C /root -zxvf /tmp/gnupg.tgz"
end

cookbook_file "/etc/sudoers.d/gooddata_writer_sso" do
  source "gooddata_writer_sso_sudoers"
  mode "0600"
  owner "root"
  group "root"
end

currentReleasePath = node['keboola-syrup']['gooddata-writer']['current-release-path']

puts 'current release path'
puts currentReleasePath

execute "copy sso script" do
  command "cp #{currentReleasePath}/GoodData/gooddata-sso.sh /usr/local/bin/gooddata-sso.sh"
  user "root"
end

file "/usr/local/bin/gooddata-sso.sh" do
  action :touch
  owner 'root'
  group 'root'
  mode '0750'
end

# cron records

action = node['keboola-syrup']['gooddata-writer']['enable_cron'].to_i > 0 ? :create : :delete

cron "gooddata writer clean" do
  user "deploy"
  hour "16"
  minute "54"
  command "/www/syrup-router/components/gooddata-writer/current/vendor/keboola/syrup/app/console gooddata-writer:clean-gooddata >/dev/null 2>&1"
  action action
end

cron "gooddata writer process-invitations" do
  user "deploy"
  minute "*/5"
  command "cd /www/syrup-router/components/gooddata-writer/current; php vendor/keboola/syrup/app/console gooddata-writer:process-invitations >/dev/null 2>&1"
  action action
end
