# Create jenkins jobs for the cookbooks we want to test
default['jenkins_ci']['jenkins']['job']['managed_directory'].tap do |job|
  job['name']          = "managed_directory"
  job['repository']    = "https://github.com/zts/chef-cookbook-managed_directory.git"
  job['branch']        = "master"
  job['foodcritic']    = true
  job['chefspec']      = true
  job['serverspec']    = true
  job['junit_results'] = true
end

default['jenkins_ci']['jenkins']['job']['mcollective'].tap do |job|
  job['name']          = "mcollective"
  job['repository']    = "https://github.com/zts/cookbook-mcollective.git"
  job['branch']        = "master"
  job['foodcritic']    = true
  job['chefspec']      = false
  job['serverspec']    = true
  job['junit_results'] = false
end

# test repo with foodcritic errors, and junit-format rspec output
default['jenkins_ci']['jenkins']['job']['test'].tap do |job|
  job['name']          = "test"
  job['repository']    = "https://github.com/zts/test-cookbook.git"
  job['branch']        = "master"
  job['foodcritic']    = true
  job['chefspec']      = true
  job['serverspec']    = false
  job['junit_results'] = true
end
