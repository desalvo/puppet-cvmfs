# @summary Configure CVMFS client
#
# Install the packages needed to mount a CVMFS file system,
# and set up the configuration files.
#
# @param repositories
#   Specifies one or more repositories to configure.
# @param quota_limit
#   Max local cache size (in MB).
# @param http_proxy
#   One or more squid proxies to be used. "DIRECT" is alway appended to the list.
# @param ipfamily_prefer
#   Optionally prefer IPv4 or IPv6 ('4' or '6')
# @param cache_base
#   Path to the local cache
# 
# @example
#  class { 'cvmfs::client':
#    repositories    => 'atlas,atlas-condb',
#    quota_limit     => 50000,
#    http_proxy      => 'http://t2-squid.mi.infn.it:3128',
#    ipfamily_prefer => '6',
#    cache_base      => '/var/cache/cvmfs',
#  }
class cvmfs::client (
  String $repositories = 'sft.cern.ch',
  Integer $quota_limit = 30000,
  Optional[String] $http_proxy = undef,
  Optional[Enum['4', '6']] $ipfamily_prefer = undef,
  Optional[String] $cache_base = undef,
) inherits cvmfs {
  include 'autofs'

  package { 'cvmfs': ensure => installed, require => Package['cvmfs-release'] }
  package { 'cvmfs-config-default': ensure => installed, require => Package['cvmfs-release'] }
  if (!defined(Package['fuse'])) {
    package { 'fuse': ensure => latest }
  }

  if (!$http_proxy) {
    $default_http_proxy = 'DIRECT'
  } else {
    $default_http_proxy = "${http_proxy};DIRECT"
  }

  file {
    '/etc/cvmfs/default.local':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('cvmfs/default.local.erb'),
      notify  => Exec['cvmfs reload'],
  }

  exec { 'cvmfs reload':
    path        => ['/bin', '/usr/bin'],
    command     => 'cvmfs_config setup && cvmfs_config reload',
    timeout     => 0,
    refreshonly => true,
    require     => [Package['cvmfs'],Package['cvmfs-config-default']],
    notify      => Service[$::autofs::params::service],
  }
}
