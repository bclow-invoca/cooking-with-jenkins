name             'jenkins_ci'
maintainer       'Brian E Clow'
maintainer_email 'bclow-github@temporalflux.org'
license          'Apache 2.0'
description      'Cookbook to ease the use of Jenkins for Chef Cookbook CI'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.6.1'

depends 'apache2', '~> 3.0.1'
depends 'apt'
depends 'docker', '= 2.9.6'
depends 'git', '~> 4.1.0'
depends 'java'
depends 'jenkins', '~> 2.6.0'
depends 'rbenv', '~> 1.7'
depends 'runit', '~> 1.2'
depends 'sysctl', '= 0.7.0'
depends 'users', '~> 1.8.2'
depends 'vagrant', '= 0.6.0'
depends 'virtualbox', '= 1.0.0'
depends 'yum'
