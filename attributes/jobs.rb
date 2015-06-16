# Create jenkins jobs for the cookbooks we want to test
default['jenkins_ci']['jenkins']['job']['template_cookbook'].tap do |job|
  job['name']          = "template_cookbook"
  job['repository']    = "https://github.com/bclow-invoca/template-cookbook.git"
  job['branch']        = "master"
  job['foodcritic']    = true
  job['chefspec']      = true
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
