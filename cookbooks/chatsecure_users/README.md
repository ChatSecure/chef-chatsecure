ow_users Cookbook
=================
Provisions the users on any OpenWatch server.

Requirements
------------

#### data bags

You will need a `users` and a `user-passwords` data bag.


`data_bags/users/username.json`

	{
	  "id": "username",
	  "ssh_keys": [
	    "ssh-rsa … username@example.com"
	  ],
	  "comment": "Firstname Lastname",
	  "uid": 2000,
	  "shell": "\/bin\/bash"
	}
	
`data_bags/user-passwords/username.json`

	{
	  "id": "username",
	  "password": "$1$oqBAwt6s$7wztG7ndBj/S3P9dyEcoc1"
	}
	


#### packages
- [user](https://github.com/fnichol/chef-user) - Manage user accounts and SSH keys. This is not the Opscode users cookbook.

Attributes
----------
TODO: List you cookbook attributes here.

e.g.
#### ow_users::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['ow_users']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### ow_users::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `ow_users` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[ow_users]"
  ]
}
```

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
©2013, OpenWatch FPC

License: AGPLv3

Authors: Chris Ballinger
