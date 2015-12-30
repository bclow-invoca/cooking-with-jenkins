# jenkins_ci cookbook

This cookbook exists to define a Chef Resource to simplify the use of Jenkins 
CI for Chef cookbook development.  Originally forked from 
[cooking-with-jenkins](https://github.com/zts/cooking-with-jenkins/) - see
[the accompanying blog post](http://www.cryptocracy.com/blog/2014/01/03/cooking-with-jenkins-test-kitchen-and-docker/)
for details and commentary. Additional inspiration came from [David Schlenk's](https://github.com/dschlenk)
fork of the project called [jenkins-cookbook-ci](https://github.com/dschlenk/jenkins-cookbook-ci).

# Requirements

Ubuntu 14.04 is supported.

`bundle exec vagrant plugin install berkshelf omnibus vagrant-berkshelf vagrant-omnibus`

To use the included Vagrantfile, you'll need Vagrant with the
vagrant-berkshelf and vagrant-omnibus plugins installed. It should
work fine under Virtualbox, but I've been using VMware as it seems to
cope better under load.

# Usage

`bundle exec vagrant up`

Checkout this repository and run `vagrant up`.  When Vagrant finishes
provisioning the machine, Jenkins will be available on
[http://localhost:8080/](http://localhost:8080/).

_Known Issue:_ The machine creates test jobs for three cookbooks, and
the first test run for each (during provisioning) fails.  I suspect
this would be fixed by restarting Jenkins after adding plugins (the
"configure-jenkins" recipe) and before defining the jobs, but it
didn't bother me enough to add the necessary hackery.

Click "Build Now" on each job and you'll see them work correctly.

# Attributes

# Recipes

# Authors

Zachary Stevens (<zts@cryptocracy.com>)

David Schlenk (<david.schlenk@spanlink.com>)

Brian E Clow (<bclow-github@temporalflux.org>)
