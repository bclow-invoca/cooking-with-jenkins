# jenkins_ci cookbook

The core idea of the cookbook is to be a "one-stop-shop" to build a cookbook
testing pipeline.  It is an effort to define the Chef Resources to simplify the
use of Jenkins CI for Chef cookbook development.  Originally forked from
[cooking-with-jenkins](https://github.com/zts/cooking-with-jenkins/) - see [the
accompanying blog
post](http://www.cryptocracy.com/blog/2014/01/03/cooking-with-jenkins-test-kitchen-and-docker/)
for details and commentary. Additional inspiration came from [David
Schlenk's](https://github.com/dschlenk) fork of the project called
[jenkins-cookbook-ci](https://github.com/dschlenk/jenkins-cookbook-ci).

# Requirements

* Ubuntu 14.04
* Vagrant
* VirtualBox
* Test Kitchen
* rbenv
* ruby 2.1.2

# Usage

The quick and dirty launch to use: `bundle exec kitchen converge`

When Vagrant finishes provisioning the machine, Jenkins will be available on
[http://localhost:8080/](http://localhost:8080/).

_Known Issues:_
1. The machine creates test jobs for two cookbooks, and the first test run for
   each (during provisioning) will fail.  I suspect this would be fixed by
   restarting Jenkins after adding plugins (the "configure-jenkins" recipe) and
   before defining the jobs, but it didn't bother me enough to add the necessary
   hackery.

   Click "Build Now" on each job and you'll see them work correctly.

2. The docker recipe needs some additional work. There have been some great
   advances in docker's upstream cookbook, and I have not had time to make
   proper adjustments.

# Attributes

# Recipes

# Authors

* Zachary Stevens (<zts@cryptocracy.com>)
* David Schlenk (<david.schlenk@spanlink.com>)
* Brian E Clow (<bclow-github@temporalflux.org>)
