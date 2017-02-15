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

    augeas{ "cvmfs release raise priority" :
        context => "/files/etc/yum.repos.d/cernvm.repo",
        changes => [
            "set cernvm/priority 1",
            "set cernvm-config/priority 1",
        ],
    }
}
