name             'jenkins-ci'
maintainer       'Brian E Clow'
maintainer_email 'bclow-github@temporalflux.org'
license          'Apache 2.0'
description      'Cookbook to ease the use of Jenkins for Chef Cookbook CI'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.0'

depends 'apt'
depends 'docker', '~> 0.37.0'
depends 'git', '~> 4.1.0'
depends 'jenkins', '~> 2.2.2'
depends 'sysctl', '= 0.6.0'
depends 'yum'
