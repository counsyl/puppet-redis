# == Class: redis::config
#
# This class sets up a configuration file for Redis.  The content or source
# the configuration file must be provided by the user.
#
# === Parameters
#
# [*config_source*]
#  The source for the configuration file resource, default is undefined.
#  Mutually exclusive with the `config_content` parameter.
#
# [*config_content*]
#  The content of the configuration file resource, default is undefined.
#  Mutually exclusive with the `config_source` parameter.
#
# [*config_file*]
#  The path to the Redis configuration file, default is platform-dependent.
#
# [*owner*]
#  The owner of the Redis configuration file, default is 'root'.
#
# [*group*]
#  The group of the Redis configuration file, default is 'root'.
#
# [*service*]
#  The name of the redis service, default is platform-dependent.
#
class redis::config(
  $config_source  = undef,
  $config_content = undef,
  $config_file    = $redis::params::config_file,
  $owner          = 'root',
  $group          = 'root',
  $service        = $redis::params::service,
) inherits redis::params {

  # Check the configuration content and source parameters.
  if $config_content and $config_source {
    fail("Cannot provide both content and source for the Redis configuration file.\n")
  } elsif (! $config_content and ! $config_source) {
    fail("Must provide either the content or source for the Redis configuration file.\n")
  }

  # Ensure the configuration file is in place with the right content.
  file { $config_file:
    ensure  => file,
    owner   => $owner,
    group   => $group,
    content => $config_content,
    source  => $config_source,
    notify  => Service[$service],
    require => Class['redis'],
  }
}
