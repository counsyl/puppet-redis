# == Class: redis
#
# Install and configure a Redis server instance.
#
# === Parameters
#
# [*ensure*]
#  The ensure parameter for the Redis package, defaults to 'installed'.
#
# [*package*]
#  The name of the Redis package to install, default is platform-dependent.
#
# [*service*]
#  The name of the Redis service to manage, default is platform-dependent.
#
# [*service_ensure*]
#  The `ensure` parameter for the Redis service resource, default is 'running'.
#
# [*service_enable*]
#  The `enable` parameter for the Redis service resource, default is true.
#
class redis(
  $ensure         = 'installed',
  $package        = $redis::params::package,
  $service        = $redis::params::service,
  $service_ensure = 'running',
  $service_enable = true,
) inherits redis::params {

  package { $package:
    ensure => $ensure,
    alias  => 'redis',
  }

  if ! ($ensure in ['absent', 'uninstalled']) {
    service { $service:
      ensure     => $service_ensure,
      alias      => 'redis',
      enable     => $service_enable,
      hasstatus  => true,
      hasrestart => true,
      require    => Package[$package],
    }
  }
}
