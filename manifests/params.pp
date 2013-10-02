# == Class: redis::params
#
# Platform-dependent parameters for Redis.
#
class redis::params {
  # Default port and bind address, should be same across platforms.
  $port = '6379'
  $bind = '127.0.0.1'
  
  case $::osfamily {
    debian: {
      $package = 'redis-server'
      $service = 'redis-server'
      $config_dir = '/etc/redis'
      $config_file = "${config_dir}/redis.conf"
      $log_dir = '/var/log/redis'
      $logfile = "${log_dir}/redis-server.log"
      $run_dir = '/var/run/redis'
      $pidfile = "${run_dir}/redis-server.pid"
      $dir = '/var/lib/redis'
      $user = 'redis'
      $group = 'redis'
    }
    default: {
      fail("Do not know how to install Redis on ${::osfamily}.\n")
    }
  }
}
