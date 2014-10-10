

package "R"

# modules are installed by apache on run
directory "/usr/lib64/R/library" do
  owner 'deploy'
  group 'apache'
end