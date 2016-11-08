define cvmfs::repository (
  $cvmfs_server_url,
  $cvmfs_public_key,
  $cvmfs_key_dir = '',
  $cvmfs_key_name = "${title}.pub"
) {
   file {"/etc/cvmfs/config.d/${title}.conf":
     owner   => 'root',
     group   => 'root',
     mode    => '0444',
     content => template("${module_name}/conf.erb")
   }

   exec {"create ${title} /etc/cvmfs/keys${cvmfs_key_dir}":
     path => ['/bin','/usr/bin'],
     command => "mkdir -p /etc/cvmfs/keys${cvmfs_key_dir}",
     unless  => "test -d /etc/cvmfs/keys${cvmfs_key_dir}"
   }

   file {"/etc/cvmfs/keys${cvmfs_key_dir}/${cvmfs_key_name}":
     owner   => 'root',
     group   => 'root',
     mode    => '0444',
     source  => $cvmfs_public_key,
     require => Exec["create ${title} /etc/cvmfs/keys${cvmfs_key_dir}"]
   }
}
