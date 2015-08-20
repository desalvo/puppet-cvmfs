class cvmfs::client (
  $repositories = 'sft.cern.ch',
  $quota_limit = 30000,
  $http_proxy = undef,
  $cache_base = undef,
) inherits cvmfs {
    include '::autofs'

    package { cvmfs: ensure => installed, require => Package["cvmfs-release"] }
    package { cvmfs-config-default: ensure => installed, require => Package["cvmfs-release"] }
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
      owner => 'root', group => 'root', mode => '0644',
      content => template("cvmfs/default.local.erb"),
      notify => Exec["cvmfs reload"]
    }

    file { "/etc/auto.cvmfs":
        ensure  => link,
        target  => '/usr/libexec/cvmfs/auto.cvmfs',
        owner   => "root",
        group   => "root",
    }

    exec { "cvmfs reload":
        path => [ "/bin", "/usr/bin" ],
        command => "cvmfs_config setup && cvmfs_config reload",
        timeout => 0,
        refreshonly => true,
        require => [Package["cvmfs"],Package["cvmfs-config-default"]],
        notify => Service[$::autofs::params::service]
    }
}
