class cvmfs {
    case $::operatingsystem {
        'centos', 'redhat', 'scientific': {
            if ($::operatingsystemrelease >= 5 and $::operatingsystemrelease < 6) {
                $osmv = "5"
            } else {
                $osmv = "6"
            }
            package { "cvmfs-release":
                ensure => installed,
                provider => rpm,
                source => "http://cvmrepo.web.cern.ch/cvmrepo/yum/cvmfs/EL/${osmv}/x86_64/cvmfs-release-2-4.el${osmv}.noarch.rpm",
            }
        }
        default: {
            fail("Unsupported operating system: ${::operatingsystem}")
        }
    }
}
