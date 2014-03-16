# == Class: redis::iptables
#
# Sets up Linux firewall rules for hosting a redis server.
#
# === Parameters
#
# [*port*]
#  The TCP port for redis traffic, defaults to 6379.
#
# [*priority*]
#  The priority for the redis firewall rules, defaults to 100.
#
# [*iniface*]
#  Interface to apply iptables to, default is undefined.
#
class redis::iptables(
  $port     = '6379',
  $priority = '100',
  $iniface  = undef,
){
  include sys::iptables

  firewall { "${priority} allow redis tcp":
    action => 'accept',
    proto  => 'tcp',
    dport  => $port,
  }
}
