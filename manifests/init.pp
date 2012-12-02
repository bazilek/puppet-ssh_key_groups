# == Class: ssh_key_groups
#
# ssh_key_groups allow you store ssh pub keys and define groups of keys ( 
# employees from one team needs access to particular unix user for example ).
# Module generates content of user .ssh/authorized_keys file based on passed
# key name or group name. See example.
# Put users ssh public keys in files/ssh_keys.
# Define groups of keys in manifests/config.pp
# Groups may include other groups as well as users. Please avoid recursion.
# Pass array of keynames to create_user define - appropriate keys will be
# placed as .ssh/authorized_keys in the home directory of created user.
#
# === Parameters
#
# You have to define $path_to_keys, $default_domain, $file_suffix variables in
# manifests/config.pp. See below:
#
# === Variables
#
# path_to_keys is path to dir containing user keys in separate files:
#  user1@mycorp.org.pub
#  user2@mycorp.org.pub
#  user3@othercorp.com.pub
#
# default_domain will be appended to key filename if you specify user
#  without domain part and 'at' sign ( @mycorp.org.pub for example)
#  If you define '@mycorp.org.pub' as default_domain, than you can use short
#  form of user keys for this domain: [ 'user1', 'user2', 'user3@othercorp.com.pub' ]
#
# file_suffix will be appended to key filename
#  maybe you want save keys with .pub file extention
#  I dont like it. So - it is empty.
#
# === Examples
# 
# see tests/create_user.pp
#  pass key_type => [ 'user4@corp.org', 'deployment' ] to create_user define
#  to place keys of all users included in deployment group and user4@corp.org key
#
# === Authors
#
# Vasil Mikhalenya <bazilek@gmail.com>
#
# === Copyright
#
# Copyright 2012 Vasil Mikhalenya 
#
class ssh_key_groups {
  include ssh_key_groups::groups
  include ssh_key_groups::config
}
