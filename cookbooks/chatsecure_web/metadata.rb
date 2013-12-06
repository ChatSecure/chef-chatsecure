name             'chatsecure_web'
maintainer       'ChatSecure'
maintainer_email 'chris@chatsecure.org'
license          'MIT'
description      'Installs/Configures chatsecure_web'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

recipe "chatsecure_web", "deploys a django application at the git repo address specified in attributes"

depends "database"
depends "python"
depends "ssh_known_hosts"