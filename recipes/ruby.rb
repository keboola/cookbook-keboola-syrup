

execute "install rvm" do
 command "curl -sSL https://get.rvm.io | bash -s stable --ruby=2.1.2"
end

execute "rvm use" do
 command "/usr/local/rvm/bin/rvm use 2.1.2 --default"
end

execute "rvm use for deploy user" do
 user "deploy"
 command "/usr/local/rvm/bin/rvm use 2.1.2 --default"
end