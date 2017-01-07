class cvmfs {
    case $::operatingsystem {
        'centos', 'redhat', 'scientific': {
            package { "cvmfs-release":
                ensure => installed,
                provider => rpm,
                source => "http://cvmrepo.web.cern.ch/cvmrepo/yum/cvmfs-release-latest.noarch.rpm",
            }
        }
        default: {
            fail("Unsupported operating system: ${::operatingsystem}")
        }
    }
}
