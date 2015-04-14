name             'jenkins-ci'
maintainer       'Brian E Clow'
maintainer_email 'bclow-github@temporalflux.org'
license          'Apache 2.0'
description      'Cookbook to demonstrate using Jenkins for Chef Cookbook CI'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.0'

# We'll be needing jenkins
depends 'apt'
depends 'jenkins', '~> 2.2.2'

# We'll be pulling cookbooks using git
depends 'git', '~> 4.1.0'

# We'll run integration tests using docker
depends 'docker', '~> 0.36.0'
