class cvmfs::client (
  $repositories = 'sft.cern.ch',
  $quota_limit = 30000,
  $http_proxy = undef,
) inherits cvmfs {

    package { cvmfs: ensure => installed, require => Package["cvmfs-release"] }
    package { cvmfs-init-scripts: ensure => installed, require => Package["cvmfs-release"] }
    package { cvmfs-auto-setup: ensure => installed, require => Package["cvmfs-release"] }
    if (!defined(Package["fuse"])) {
        package { fuse: ensure => latest }
    }

    if (!$http_proxy) {
        $default_http_proxy = "DIRECT"
    } else {
        $default_http_proxy = "${http_proxy};DIRECT"
    }
    file {
      "/etc/cvmfs/default.local":
      owner => root, group => root, mode => 644,
      content => template("cvmfs/default.local.erb"),
      notify => Exec["cvmfs reload"]
    }

    file { "/etc/auto.cvmfs":
        ensure  => file,
        owner   => "root",
        group   => "root",
        mode    => 0755,
    }

    exec { "cvmfs reload":
        path => [ "/bin", "/usr/bin" ],
        command => "cvmfs_config reload",
        timeout => 0,
        refreshonly => true,
        require => [Package["cvmfs"],Package["cvmfs-init-scripts"],Package["cvmfs-auto-setup"]]
    }

    #service { "cvmfs":
    #    restart   => "/usr/bin/cvmfs_config reload",
    #    subscribe => File["/etc/cvmfs/default.local"]
    #}
}
