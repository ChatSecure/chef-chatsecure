# chatsecure.org setup

TODO: write up chef cookbooks to automate this process

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
