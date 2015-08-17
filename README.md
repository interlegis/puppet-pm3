# puppet-pm3
Puppet Module for installing and managing Interlegis Portal Modelo 3 servers, a customized Plone Portal for Brazilian Legislative Power.

Requires:
 - https://github.com/interlegis/puppet-plone


To deploy a Portal Modelo Application Server:

```
class { "pm3::appserver": 
  numberInstances => 2,           # Number of zope instances to deploy
  zeo_ip          => '127.0.0.1', # IP Address of the ZEO server
  zeo_port        => '8100'       # Port number of the ZEO server
}
```

To deploy a Portal Modelo Database (ZEO) Server:

```
class { "pm3::dbinstance":
  type          => 'primary',
  port          => '2500',
  zrs_repl_ip   => '0.0.0.0',
  zrs_repl_port => '5000',
  blobdir       => '${buildout:directory}/var/blobstorage',
  backups_dir   => '',
  invalid_queue => '100',
}

```
