#
# Cookbook Name:: chatsecure_users
# Attributes:: default
#
# Copyright 2013, ChatSecure
#
# Licensed under the AGPLv3
#

default['chatsecure_users']['active_gids'] = []

default['chatsecure_users']['admins_gid'] = 999
default['chatsecure_users']['app_service_gid'] = 500

default['chatsecure_users']['users_databag_name'] = "users"
default['chatsecure_users']['groups_databag_name'] = "groups"
default['chatsecure_users']['groups_databag_item_name'] = "groups"
default['chatsecure_users']['passwords_databag_name'] = "user-passwords"
default['chatsecure_users']['passwords_databag_item_name'] = "passwords"
