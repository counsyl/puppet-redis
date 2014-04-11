redis
=====

This module installs and configures a Redis server instance on a Debian platform.  To use, simply:

```puppet
include redis
```

Also included are the classes:

* `redis::config`: Allows specifiying a configuration file via file source or template.
* `redis::iptables`: Sets up a firewall rule allowing external access to a Redis instance -- use
   of this requires the [puppetlabs-firewall](https://github.com/puppetlabs/puppetlabs-firewall)
   module.

License
-------

Apache License, Version 2.0

Contact
-------

Justin Bronn <justin@counsyl.com>

Support
-------

Please log tickets and issues at https://github.com/counsyl/puppet-redis
