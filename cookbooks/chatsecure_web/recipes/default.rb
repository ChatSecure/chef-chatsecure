#
# Cookbook Name:: chatsecure_web
# Recipe:: default
#
# Copyright 2013, Chris Ballinger
#
# Licensed under the AGPLv3
#


# SSL
ssl_databag_name = node['chatsecure_web']['ssl_databag_name']
certs_item = node['chatsecure_web']['ssl_databag_certs_item']
keys_item = node['chatsecure_web']['ssl_databag_keys_item']
certs = data_bag_item(ssl_databag_name, certs_item)
keys = data_bag_item(ssl_databag_name, keys_item)
cert_name = node['chatsecure_web']['ssl_cert']
key_name = node['chatsecure_web']['ssl_key']
ssl_key = keys[key_name]
cert = certs[cert_name]

directory node['chatsecure_web']['ssl_dir'] do
  mode "077"
  action :create
  recursive true
end

# Copy SSL cert
file node['chatsecure_web']['ssl_dir'] + node['chatsecure_web']['ssl_cert'] do
  content cert
  mode "077"
  action :create
end

# Copy SSL key
file node['chatsecure_web']['ssl_dir'] + node['chatsecure_web']['ssl_key'] do
  content ssl_key
  mode "077"
  action :create
end

# Setup postgresql database
postgresql_database node['chatsecure_web']['db_name'] do
  connection ({
  		:host => "127.0.0.1", 
  		:port => node['chatsecure_web']['db_port'], 
  		:username => node['chatsecure_web']['db_user'], 
  		:password => node['postgresql']['password']['postgres']
  })
  action :create
end

# Setup virtualenvs

directory node['chatsecure_web']['virtualenvs_dir'] do
  owner node['chatsecure_web']['service_user']
  group node['chatsecure_web']['service_user_group']
  recursive true
  action :create
end

virtualenv_path = node['chatsecure_web']['virtualenvs_dir'] + node['chatsecure_web']['virtualenv_name']
python_virtualenv virtualenv_path do
  owner node['chatsecure_web']['service_user']   
  group node['chatsecure_web']['service_user_gid']
  action :create
end

# Make uwsgi params file
cookbook_file "uwsgi_params" do
  path "/etc/nginx/uwsgi_params"
  owner node['nginx']['user']
  group node['nginx']['group']
  action :create
end

python_pip "uwsgi" do
  virtualenv virtualenv_path
end


# Git stuff
# Make git checkout dir
directory node['chatsecure_web']['app_root'] do
  owner node['chatsecure_web']['git_user']
  group node['chatsecure_web']['service_user_group']
  recursive true
  action :create
end

ssh_known_hosts_entry 'github.com'

# Git checkout
git node['chatsecure_web']['git_root'] do
   repository node['chatsecure_web']['git_url'] 
   revision node['chatsecure_web']['git_rev']  
   action :sync
   user node['chatsecure_web']['git_user']
   group node['chatsecure_web']['service_user_group']
end

template node['chatsecure_web']['git_root'] + "/.git/hooks/post-update" do
  source "post-update.erb"
  owner node['chatsecure_web']['git_user']
  group node['chatsecure_web']['service_user_group']
  variables({
    :app_root => node['chatsecure_web']['app_root']
  })
end

# Git checkout
git node['chatsecure_web']['app_root'] do
   repository node['chatsecure_web']['git_root']
   revision node['chatsecure_web']['git_rev']  
   action :sync
   user node['chatsecure_web']['git_user']
   group node['chatsecure_web']['service_user_group']
end

secrets = data_bag_item(node['chatsecure_web']['secret_databag_name'] , node['chatsecure_web']['secret_databag_item_name'])
django_secret_key = secrets['django_secret_key']
# Make local_settings.py 
app_name = node['chatsecure_web']['app_name']
template node['chatsecure_web']['app_root'] + "/#{app_name}/#{app_name}/local_settings.py" do
    source "local_settings.py.erb"
    owner node['chatsecure_web']['git_user']   
    group node['chatsecure_web']['service_user_group']   
    mode "770"
    variables({
      :django_secret_key => django_secret_key,
      :db_name => node['chatsecure_web']['db_name'],
      :db_user => node['chatsecure_web']['db_user'],
      :db_password => node['postgresql']['password']['postgres'],
      :db_host => node['chatsecure_web']['db_host'],
      :db_port => node['chatsecure_web']['db_port'],
      :chef_node_name => Chef::Config[:node_name]
    })
    action :create
end


# Make Nginx log dirs
directory node['chatsecure_web']['log_dir'] do
  owner node['nginx']['user']
  group node['nginx']['group']
  recursive true
  action :create
end

# Nginx config file
template node['nginx']['dir'] + "/sites-enabled/chatsecure_web.nginx" do
    source "chatsecure_web.nginx.erb"
    owner node['nginx']['user']
    group node['nginx']['group']
    variables({
    :http_listen_port => node['chatsecure_web']['http_listen_port'],
    :https_listen_port => node['chatsecure_web']['https_listen_port'],
    :domain => node['chatsecure_web']['domain'],
    :internal_port => node['chatsecure_web']['internal_port'],
    :ssl_cert => node['chatsecure_web']['ssl_dir'] + node['chatsecure_web']['ssl_cert'],
    :ssl_key => node['chatsecure_web']['ssl_dir'] + node['chatsecure_web']['ssl_key'],
    :app_root => node['chatsecure_web']['app_root'],
    :access_log => node['chatsecure_web']['log_dir'] + node['chatsecure_web']['access_log'],
    :error_log => node['chatsecure_web']['log_dir'] + node['chatsecure_web']['error_log'],
    :static_path => node['chatsecure_web']['app_root'] + node['chatsecure_web']['static_files']
    })
    notifies :restart, "service[nginx]"
    action :create
end

# Upstart service config file
template "/etc/init/" + node['chatsecure_web']['service_name'] + ".conf" do
    source "upstart.conf.erb"
    owner node['chatsecure_web']['service_user_id'] 
    group node['chatsecure_web']['service_user_gid'] 
    variables({
    :service_user => node['chatsecure_web']['service_user_id'],
    :virtualenv_path => virtualenv_path,
    :app_root => node['chatsecure_web']['app_root'],
    :app_name => node['chatsecure_web']['app_name'],
    :access_log_path => node['chatsecure_web']['log_dir'] + node['chatsecure_web']['service_log'],
    :error_log_path => node['chatsecure_web']['log_dir'] + node['chatsecure_web']['service_error_log'],
    :app_port => node['chatsecure_web']['internal_port'],
    :app_workers => node['chatsecure_web']['app_workers']
    })
end

# Make service log file
file node['chatsecure_web']['log_dir'] + node['chatsecure_web']['service_log']  do
  owner node['chatsecure_web']['service_user']
  group node['chatsecure_web']['service_user_group'] 
  action :create_if_missing # see actions section below
end

# Make service error log file
file node['chatsecure_web']['log_dir'] + node['chatsecure_web']['service_error_log']  do
  owner node['chatsecure_web']['service_user']
  group node['chatsecure_web']['service_user_group'] 
  action :create_if_missing # see actions section below
end

# Register capture app as a service
service node['chatsecure_web']['service_name'] do
  provider Chef::Provider::Service::Upstart
  action :enable
end
