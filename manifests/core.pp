#core.pp

class pm3::core {

  $sys_packages = [ 
                    'libldap2-dev',
                    'libsasl2-dev',
                    'libbz2-dev',
                    'libreadline6-dev',
                    'readline-common',
                    'python-imaging',
                    'python-docutils',
                    'python-psycopg2',
                    'xlhtml',
                    'xpdf', 
                    'xsltproc',
                    'ppthtml', 
                    'pdftohtml',
                    'poppler-utils',
                    'wv',
                    'unzip',
                  ]
  package { $sys_packages: ensure => "installed" }

}
