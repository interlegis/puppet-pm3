# appserver.pp
# requires https://github.com/interlegis/puppet-plone.git

class pm3::appserver ( $numberInstances = 2,           # Number of zope instances deployed
                       $zeo_ip          = '127.0.0.1', # IP Address of the ZEO server
                       $zeo_port        = '8100',      # Port number of the ZEO server
                       $default_portal  = true,        # Whether to add a default Plone Site
                       $bout_cache_file = undef,       # An URL with the location of a Buildout Cache
                     ) {

  class { "plone":
    type                => 'zeoclient',
    create_default_inst => false,
  }
  
  notify { "ZODB Socket is $zeo_ip:$zeo_port.": }

  $instNos = range("0", "${numberInstances-1}")
  
  $staticParam = { zeo_ip          => $zeo_ip,
                   zeo_port        => $zeo_port,
                   default_portal  => $default_portal,
                   bout_cache_file => $bout_cache_file,
                  }
  $dynParam = { port => "81%02d" }
  $instHash = create_resources_hash_from( "pm3Inst%s", 
                                          $instNos, 
                                          $staticParam, 
                                          $dynParam)
  create_resources ( "pm3::instance", $instHash )

}
