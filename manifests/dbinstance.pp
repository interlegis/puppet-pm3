# dbinstance.pp

define pm3::dbinstance ( $type                   = 'primary',
                         $port                   = '2500',
                         $zrs_repl_ip            = '0.0.0.0',
                         $zrs_repl_port          = '5000',
                         $blobdir                = '${buildout:directory}/var/blobstorage',
                         $backups_dir            = '',
                         $invalid_queue          = '100',
                         $pack_days              = '7',
                         $backups_keep           = '2',
                         $backups_keep_blob_days = '14',
                       ) {

  plone::zeo { "$name":
    port                   => $port,
    zrs_role               => $type,
    zrs_repl_host          => "${zrs_repl_ip}:${zrs_repl_port}",
    blobstorage_dir        => $blobdir,
    backups_dir            => $backups_dir,
    invalid_queue          => $invalid_queue,
    pack_days              => $pack_days,
    backups_keep           => $backups_keep,
    backups_keep_blob_days => $backups_keep_blob_days,
  }
  
}
