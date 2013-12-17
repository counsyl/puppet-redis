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
    alias  => 'redis-server',
  }

  if $::kernel == 'Linux' {
    # See http://redis.io/topics/faq for more information on why this
    # is necessary under 'Background saving is failing with a fork() error
    # under Linux even if I've a lot of free RAM!' question.
    $sysctl = '/etc/sysctl.conf'
    $overcommit_line = 'vm.overcommit_memory=1'

    # The line in sysctl.conf allows overcommit setting to persist across
    # reboots.
    file_line { 'vm.overcommit_memory':
      path    => $sysctl,
      line    => $overcommit_line,
      match   => 'vm.overcommit_memory',
      notify  => Exec['sysctl-overcommit'],
    }

    # Use `exec` to ensure current live kernel parameter is changed.
    exec { 'sysctl-overcommit':
      command     => "/sbin/sysctl -w ${overcommit_line}",
      user        => 'root',
      refreshonly => true,
    }
  }

  if ! ($ensure in ['absent', 'uninstalled']) {
    service { $service:
      ensure     => $service_ensure,
      alias      => 'redis-server',
      enable     => $service_enable,
      hasstatus  => true,
      hasrestart => true,
      require    => Package[$package],
    }
  }
}
