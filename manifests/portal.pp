#portal.pp

define pm3::portal ( $instance_name = 'pm3Inst0',
                     $instance_port = '8100',  
                     $install_dir   = '/srv/plone',
                     $smtp_server   = 'localhost',
                     $smtp_port     = '25',
                     $email         = 'root@localhost',
                     $site_title    = 'Portal Modelo 3',
                     $caching_proxy = 'localhost', 
                    ) {

  if !defined (Plone::Site["${name}"]){
    plone::site { "${name}":
      site_name         => "${name}",
      container_path    => "/",
      id                => "portal",
      add_mountpoint    => true,
      default_language  => 'pt-br',
      instance_name     => $instance_name,
      post_extras       => "${install_dir}/${instance_name}/cfg_site_${name}.py",
      products          => 'plone.app.caching',
      profiles_initial  => 'Products.CMFPlone:plone-content',
      refresh_only      => false,
      unless            => "/bin/netstat -tunap|grep 0.0.0.0:${instance_port} && /usr/bin/wget -q -O - http://localhost:${instance_port}/portal/favicon.ico > /dev/null",
      profiles          => [ 'interlegis.portalmodelo.policy:default',
                             'plone.app.caching:with-caching-proxy' ]
    }

    file { "${install_dir}/${instance_name}/cfg_site_${name}.py":
      ensure  => present,
      mode    => 'ug+x',
      content => template('pm3/cfg_pm3.py.erb')
    }
  }


}
