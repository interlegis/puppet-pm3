#portal.pp

define pm3::portal ( $instance_name  = 'pm3Inst0',
                     $instance_port  = '8100',  
                     $install_dir    = '/srv/plone',
                     $smtp_server    = 'localhost',
                     $smtp_port      = '25',
                     $email          = 'root@localhost',
                     $site_title     = 'Portal Modelo 3',
                     $caching_proxy  = 'localhost',
                     $upgrade_portal = false,
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
      products          => [ 'plone.app.caching',
                             'plone.resource',
                             'BrFieldsAndWidgets',
                             'collective.oembed',
                             'collective.z3cform.datetimewidget',
                             'plone.formwidget.datetime',
                             'plone.formwidget.autocomplete',
                             'plone.formwidget.contenttree',
                             'plone.app.dexterity',
                             'sc.social.like',
                             'plone.app.event',
                             'plone.app.intid',
                             'plone.app.theming',
                             'interlegis.portalmodelo.buscadores',
                             'interlegis.portalmodelo.api',
                             'interlegis.portalmodelo.ombudsman',
                             'interlegis.portalmodelo.transparency'
                           ],
      profiles_initial  => [ 'Products.CMFPlone:plone-content',
                             'interlegis.portalmodelo.policy:default' 
                           ],
      refresh_only      => false,
      unless            => "/bin/netstat -tunap|grep 0.0.0.0:${instance_port} && /usr/bin/wget -q -O - http://localhost:${instance_port}/portal/favicon.ico > /dev/null",
      profiles          => 'plone.app.caching:with-caching-proxy',
      upgrade_portal    => $upgrade_portal, 
    }

    file { "${install_dir}/${instance_name}/cfg_site_${name}.py":
      ensure  => present,
      mode    => 'ug+x',
      content => template('pm3/cfg_pm3.py.erb')
    }
  }


}
