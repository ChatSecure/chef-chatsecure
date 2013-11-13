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

--------------------------------------

# Initial Setup


Initial setup do some of this: http://web.archive.org/web/20131105202146/http://plusbryan.com/my-first-5-minutes-on-a-server-or-essential-security-for-linux-servers

# User Accounts 

Users:

* administrator account
* git

User groups

* admin

# Production Environment

Virtualenvs in `/opt/virtualenvs` 775, root/admin

# Git Deploy

http://danbarber.me/using-git-for-deployment/ and http://git-scm.com/book/en/Git-on-the-Server-Setting-Up-the-Server

`/var/git/chatsecure-web.git` 755 git/root -> this is the git remote


Set up git remote:	



# nginx configuration

Read this later: http://adambard.com/blog/start-to-finish-serving-mysql-backed-django-w/


Install nginx from nginx.org

	$ apt-get install nginx