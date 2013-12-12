# chatsecure.org chef repo

Chef is way better than provisioning servers by hand.

## Vagrant

Install [Vagrant](http://www.vagrantup.com), [VirtualBox](https://www.virtualbox.org), and then install these plugins.

    $ vagrant plugin install vagrant-omnibus
    $ vagrant plugin install vagrant-berkshelf

Then you should be able to bring up the VM:

	$ vagrant up
	
Provision the current roles/recipes defined in the `Vagrantfile`:

	$ vagrant provision
	
Other useful commands are `vagrant destroy` to destroy the VM, `vagrant ssh` to ssh into the VM, `vagrant halt` and `vagrant suspend` to halt/suspend. Sometimes you have to do `vagrant reload` as well when changing VM configuration.

## Deploying

Install the latest version of Chef, knife-solo, and berkshelf for your operating system.

    $ gem install chef knife-solo berkshelf
    
Install chef-solo on the remote server with knife-solo:

    $ knife solo prepare user@example.com
    
Provision the server with the latest cookbooks (similar to `vagrant provision`):

    $ knife solo cook user@example.com

## Data Bags

The `data_bags` directory should look like this:

    groups
        groups.json
    secrets
        secrets.json
    ssl
        certs.json
        keys.json
    user-passwords
    	passwords.json
    users
        user1.json
        user2.json
        user3.json
        
## Nodes

For some reason chef-solo breaks if you include too much stuff in your json file. In the `nodes` directory include a node `example.com.json`:

	{
	   "name": "example.com",
	   "postgresql": {
	      "password": {
	         "postgres": "example_password"
	      }
	   },
	   "run_list": [
	      "role[nginx]",
	      "role[base]",
	      "role[security]",
	      "role[users]",
	      "role[web]"
	   ]
	}
	
## Git Deploys

Now you can deploy application code with git:

    $ git remote add vagrant ssh://git@127.0.0.1:2222/var/git/chatsecure-web.git
    $ git remote add production git@beta.chatsecure.org:/var/git/chatsecure-web.git
    $ git push production master