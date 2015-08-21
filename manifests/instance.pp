# instance.pp

define pm3::instance ( $port,
                       $zeo_ip,
                       $zeo_port,
                       $install_dir     = '/srv/plone',
                       $blobdir         = '${buildout:directory}/var/blobstorage',
                       $shared_blob     = 'off',
                       $default_portal  = false,
                       $bout_cache_file = undef, 
                      ) {
  include pm3::core

  plone::instance { "$name":
    port => $port,
    zeo_client => true,
    blobstorage_dir => $blobdir,
    bout_cache_file => $bout_cache_file,
    enable_tempstorage => true,
    zeo_address => "$zeo_ip:$zeo_port",
    custom_extends => ['https://github.com/interlegis/portalmodelo/raw/master/buildout.d/versions.cfg'],
    custom_eggs => [ 'interlegis.portalmodelo.policy' ],
    find_links => [ 'http://dist.plone.org',
                    'http://download.zope.org/ppix/',
                    'http://download.zope.org/distribution/',
                    'http://effbot.org/downloads',
                    'http://dist.plone.org/release/4.3-latest',
                    'https://github.com/interlegis/collective.recipe.plonesite/tarball/master#egg=collective.recipe.plonesite-1.8.6',
                    'https://github.com/interlegis/collective.recipe.filestorage/tarball/master#egg=collective.recipe.filestorage-0.7il1',
                    'http://dist.plone.org/thirdparty',
                    'https://github.com/interlegis/rows/archive/0.1.0a0.zip#egg=rows-0.1.0a0',
                    'https://github.com/simplesconsultoria/s17.taskmanager/archive/1.0b2.zip#egg=s17.taskmanager-1.0b2'],
    custom_params => { zcml => 'interlegis.portalmodelo.policy',
                       environment-vars =>
                        [ 'CHAMELEON_CACHE ${buildout:directory}/var/chameleon-cache',
                          'CHAMELEON_DEBUG false',
                          'CHAMELEON_RELOAD true',
                          'CHAMELEON_EAGER true',
                          'PYTHON_EGG_CACHE ${buildout:directory}/var/.python-eggs',
                          'PTS_LANGUAGES en, es, pt-br',
                          'zope_i18n_allowed_languages en, es, pt_BR',
                          'zope_i18n_compile_mo_files true',
                        ],
                        shared-blob => $shared_blob,
                      },
  }

  ensure_resource ( 'file',
                    "$install_dir/$name/var/chameleon-cache",
                    { ensure => directory,
                      mode   => 2770,
                      owner  => 'plone_daemon',
                      group  => 'plone_group',
                      require => Plone::Instance["$name"],
                    }
                  )

  # A codificacao padrao do Python deve ser UTF...
  ensure_resource ( 'file',
                    "$install_dir/$name/lib/python2.7/sitecustomize.py",
                    { ensure  => present,
                      owner   => 'plone_buildout',
                      group   => 'plone_group',
                      content => "# sitecustomize.py\nimport sys\nsys.setdefaultencoding('utf-8')",
                      require => Plone::Instance["$name"],
                    }
                  )

  if $default_portal {
    ensure_resource ( 'pm3::portal',
                      'portal',
                      { instance_name => "$name",
                        instance_port => "$port",
                        install_dir   => "${install_dir}",
                      }
                    )
  } 

}
