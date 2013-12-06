name             'chatsecure_users'
maintainer       'Chris Ballinger'
maintainer_email 'chris@chatsecure.org'
license          'AGPLv3'
description      'Installs/Configures chatsecure_users'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

recipe "chatsecure_users", "setup ChatSecure user accounts"

depends "user"
depends "sudo"

attribute "chatsecure_users/admins_gid",
  :display_name => "Admins GID",
  :description => "Group ID of the Admins Group",
  :default => "999"

# See /attributes/default.rb 