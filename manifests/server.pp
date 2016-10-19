class cvmfs::server (
) inherits cvmfs {
    include '::apache::mod::headers'
    class {'::apache': purge_configs => false }
    package { cvmfs: ensure => installed, require => Package["cvmfs-release"] }
    package { cvmfs-server: ensure => installed, require => Package["cvmfs-release"] }
}
