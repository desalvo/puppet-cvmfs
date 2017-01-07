puppet-cvmfs
======

Puppet module for managing CVMFS.

#### Table of Contents
1. [Overview - What is the cvmfs module?](#overview)

Overview
--------

This module is intended to be used to manage CVMFS customizations. CVMFS is an HTTP based filesystem,
part of the [CernVM](http://cernvm.cern.ch) project.
Both the client and server setups are supported. The server setup need a recent kernel (>= 4.2.0) to work properly via OverlayFS. The kernel-ml series from elrepo is available for both el6 and el7.

Usage
-----

### Client example

This is a simple example to add the atlas and sft CERN repositories, using a quota limit of 10 GB for the cache
size and a local squid proxy mysquid.example.com. The module will use the current defaults:

* repositories = 'sft.cern.ch'
* quota_limit = 30000
* no http_proxy
* default cache base

**Defining a cvmfs client customization**

```cvmfs
class { 'cvmfs::client':
    repositories => 'atlas.cern.ch,sft.cern.ch',
    quota_limit  => 10000,
    http_proxy   => 'http://mysquid.example.com:3128',
    cache_base   => '/var/cache/cvmfs'
}
```

### Server example

This is a simple example to configure a server. It requires a recent kernel (> 4.2.0) to work properly.

```cvmfs_server
include '::cvmfs::server'
```

### Adding a repository

You can add custom repositories using in the following way:

```cvmfs_add_repo
cvmfs::repository {'myrepo.example.com':
   cvmfs_server_url => 'http://cvmfs.example.com/cvmfs/myrepo.example.com',
   cvmfs_public_key => 'puppet:///modules/myrepo/myrepo.example.com.pub',
   cvmfs_key_dir    => '/myrepo',
}
```

Where:

* cvmfs_server_url: repository URL
* cvmfs_public_key: public key of the repository
* cvmfs_key_dir: (optional) subdir in the keys directory to use

Limitations
------------

* This module does not install the needed kernel for servers, this is left to the users. Only stratum-0 servers have been tested.

Contributors
------------

* https://github.com/desalvo/puppet-cvmfs/graphs/contributors

Release Notes
-------------

**0.1.6**

Change repository name

**0.1.5**

Support for multiple repositories in the same key dir

**0.1.4**

Initial support for server and custom repositories

**0.1.3**

Support for cache_base option and puppet 4

**0.1.2**

Support for cvmfs 2.1.20

**0.1.1**

Fix for cvmfs 2.1 service reload

**0.1.0**

* Initial version
