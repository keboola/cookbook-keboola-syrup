if node['keboola-syrup']['docker']['install_docker'].to_i  > 0

  execute "install docker from amazon repo" do
    command "yum -y install docker-18.06.1ce-7.25.amzn1"
  end

  file '/etc/sysconfig/docker' do
    action :delete
  end

  cookbook_file "/etc/sudoers.d/docker" do
    source "docker_sudoers"
    mode "0600"
    owner "root"
    group "root"
 end

 directory '/etc/docker' do
   owner 'root'
   group 'root'
   mode '0755'
   action :create
 end


  if node['keboola-syrup']['docker']['storage_driver'] == 'devicemapper'
    ## Device mapper - steps from https://docs.docker.com/engine/userguide/storagedriver/device-mapper-driver/
    execute "Create an LVM physical volume (PV)" do
      command "pvcreate #{node['keboola-syrup']['docker']['data_device']}"
    end

    execute "Create a new volume group (VG) " do
      command "vgcreate docker  #{node['keboola-syrup']['docker']['data_device']}"
    end

    execute "Create a new 90GB logical volume (LV) called data " do
      command "lvcreate --wipesignatures y -n thinpool docker -l 95%VG"
    end

    execute "Create a new logical volume (LV) called metadata" do
      command "lvcreate --wipesignatures y -n thinpoolmeta docker -l 1%VG"
    end

    execute "Convert the pool to a thin pool." do
      command "lvconvert -y --zero n -c 512K --thinpool docker/thinpool --poolmetadata docker/thinpoolmeta"
    end

    cookbook_file "/etc/lvm/profile/docker-thinpool.profile" do
      source "docker-thinpool.profile"
      mode "0600"
      owner "root"
      group "root"
    end

    execute "Apply your new lvm profile" do
      command "lvchange --metadataprofile docker-thinpool docker/thinpool"
    end

    cookbook_file "/etc/docker/daemon.json" do
      source "docker-daemon-devicemapper.json"
      mode "0600"
      owner "root"
      group "root"
    end

  end

  if node['keboola-syrup']['docker']['storage_driver'] == 'overlay2'
    ## overlay2 https://github.com/keboola/docker-bundle/issues/198
    cookbook_file "/etc/docker/daemon.json" do
      source "docker-daemon-overlay2.json"
      mode "0600"
      owner "root"
      group "root"
    end
    
  end

  service "docker" do
    action :enable
  end

  service "docker" do
    action :start
  end

  execute "reject connections to local subnets" do
    command "iptables --insert DOCKER-USER --in-interface docker+ --destination 10.0.0.0/8 --jump REJECT  --reject-with icmp-port-unreachable"
  end

  execute "reject connections to instance metadata" do
    command "iptables --insert DOCKER-USER --in-interface docker+ --destination 169.254.169.254/32 --jump REJECT  --reject-with icmp-port-unreachable"
  end

  execute "allow access to AWS DNS server" do
    command "iptables --insert DOCKER-USER --in-interface docker+ --destination 10.0.0.2/32 --jump ACCEPT"
  end

  execute "allow access to Redshift Subnet 1" do
    command "iptables --insert DOCKER-USER --in-interface docker+ --destination 10.0.151.0/24 --jump ACCEPT"
  end

  execute "allow access to Redshift Subnet 2" do
    command "iptables --insert DOCKER-USER --in-interface docker+ --destination 10.0.150.0/24 --jump ACCEPT"
  end

  execute "allow access to subnet NetHost_VPN_1a" do
    command "iptables --insert DOCKER-USER --in-interface docker+ --destination 10.0.222.0/24  --jump ACCEPT"
  end

  execute "allow access to VPN VPC subnet" do
    command "iptables --insert DOCKER-USER --in-interface docker+ --destination 10.2.0.0/24  --jump ACCEPT"
  end

  execute "save iptables" do
    command "service iptables save"
  end

  if node['keboola-syrup']['enable_docker_monitoring'].to_i > 0
    include_recipe "keboola-syrup::docker-monitoring"
  end

  # init job - receive docker jobs
  template "/etc/init/queue.queue-receive.conf" do
    source 'queue.queue-receive.conf.erb'
    owner 'root'
    group 'root'
    mode 00644
  end

  # collect container stats
  template "/etc/init/docker.collect-container-stats.conf" do
    source 'docker.collect-container-stats.conf.erb'
    owner 'root'
    group 'root'
    mode 00644
    variables({
      :queue => node['keboola-syrup']['docker']['container_stats_queue']
     })
  end

end
