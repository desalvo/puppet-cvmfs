class cvmfs {
    case $::operatingsystem {
        'centos', 'redhat', 'scientific': {
            package { "cvmfs-release":
                ensure => installed,
                provider => rpm,
                source => "http://cvmrepo.web.cern.ch/cvmrepo/yum/cvmfs/EL/${operatingsystemmajrelease}/x86_64/cvmfs-release-2-4.el${operatingsystemmajrelease}.noarch.rpm",
            }
        }
        default: {
            fail("Unsupported operating system: ${::operatingsystem}")
        }
    }
}
