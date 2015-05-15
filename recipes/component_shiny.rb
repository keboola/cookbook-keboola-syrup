package "R"

execute "install shiny R package" do
  command "R -e \"install.packages('shiny', repos='http://cran.rstudio.com/')\""
end


execute "download shiny server" do
  command "wget https://s3.amazonaws.com/rstudio-shiny-server-pro-build/centos-5.9/x86_64/shiny-server-commercial-1.3.0.540-rh5-x86_64.rpm > /tmp/shiny.rpm"
end

execute "install shiny server" do
  command "yum install --nogpgcheck /tmp/shiny.rpm"
end
