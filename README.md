Keboola Syrup Cookbook
==============

This cookbook installs Syrup with all it's dependencies.
Cloudformation template is also provided with cookbook and performs these actions:
 * Creates EC2 instance in VPC and provision it with Syrup using this cookbook. Node name is same as stack name
 * Creates and associate DNS entry for instance `stack_name.keboola.com`



Attributes
----------

e.g.
#### syrup::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['keboola-syrup']['cron_gooddata_writer_enabled'] </tt></td>
    <td>Boolean</td>
    <td>whether to start gooddata writer cron tasks</td>
    <td><tt>false</tt></td>
  </tr>
</table>

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
