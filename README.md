Keboola Syrup Cookbook
==============

This cookbook installs Syrup and Transformation API with all it's dependencies.
Cloudformation template is also provided with cookbook and performs these actions:
 * Creates EC2 instance in VPC and provision it with Syrup using this cookbook. Node name is same as stack name
 * Creates and associate DNS entries for instance:
   * `stack_name.keboola.com`
   * `stack_name-transformation.keboola.com`


Usage
-----
#### keboola-syrup::default

Just include `keboola-syrup` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[keboola-syrup]"
  ]
}
```

Description
-----------

 * Cookbook Keboola common is used for installation of basic packages https://github.com/keboola/cookbook-keboola-common
 * Syrup router is cloned and then all components are fetched. All components are listed in https://github.com/keboola/cookbook-keboola-syrup/blob/master/attributes/default.rb
 * `parameters.yml` file for each component is downloaded from S3
 * Transformation api is fetched and installed


Troubleshooting
---------------
Each step of instance provisioning provides logs, these can be helplful when something goes wrong during instance provisioning.

* `/var/log/cloud-init.log` - Cloud init script
* `/var/log/cfn-init.log` - Cloudformation init script
* `/var/init/bootstrap.log` - Downloading chef and required recipes using Berkshelf
* `/var/init/storage.log` - Disks settings
* `/var/init/chef_solo.log` - Chef provisioning

If you want to run chef provisioning again run following command as root on provisioned instance:
`chef-solo -j /var/init/node.json --config /var/init/solo.rb --node-name STACK_NAME`