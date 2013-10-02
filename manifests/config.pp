# == Class: redis::config
#
# This class sets up a configuration file for Redis.  The content or source
# the configuration file must be provided by the user.
#
# === Parameters
#
# [*source*]
#  The source for the configuration file resource, default is undefined.
#  Mutually exclusive with the `content` parameter.
#
# [*content*]
#  The content of the configuration file resource, default is undefined.
#  Mutually exclusive with the `source` parameter.
#
# [*path*]
#  The path to the Redis configuration file, default is platform-dependent.
#
# [*owner*]
#  The owner of the Redis configuration file, default is 'root'.
#
# [*group*]
#  The group of the Redis configuration file, default is 'root'.
#
# [*mode*]
#  The mode of the Redis configuration file, default is '0644'.
#
class redis::config(
  $source  = undef,
  $content = undef,
  $path    = $redis::params::config_file,
  $owner   = 'root',
  $group   = 'root',
  $mode    = '0644',
) inherits redis::params {

  # Check the configuration content and source parameters.
  if $content and $source {
    fail("Cannot provide both content and source for the Redis configuration file.\n")
  } elsif (! $content and ! $source) {
    fail("Must provide either the content or source for the Redis configuration file.\n")
  }

  # Ensure the configuration file is in place with the right content.
  file { $path:
    ensure  => file,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => $content,
    source  => $source,
    notify  => Service['redis'],
    require => Package['redis'],
  }
}
