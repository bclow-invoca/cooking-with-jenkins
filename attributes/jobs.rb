# Cookbook commands
default['jenkins_ci']['jenkins']['command']['base'].tap do |command|
  command['base']          = 'bundle install --deployment'
  command['foodcritic']    = 'bundle exec rake lint'
  command['chefspec']      = 'bundle exec rake spec'
  command['serverspec']    = 'bundle exec rake kitchen:all'
end
default['jenkins_ci']['jenkins']['command']['template_cookbook'].tap do |command|
  command['base']          = 'bundle install --deployment'
  command['foodcritic']    = 'bundle exec rake test:foodcritic'
  command['chefspec']      = 'bundle exec rake test:chefspec'
  command['serverspec']    = ['bundle exec berks', 'bundle exec rake test:serverspec']
end

# Create jenkins jobs for the cookbooks we want to test
default['jenkins_ci']['jenkins']['job']['template_cookbook'].tap do |job|
  job['name']          = "template_cookbook"
  job['repository']    = "https://github.com/bclow-invoca/template-cookbook.git"
  job['branch']        = "master"
  job['foodcritic']    = true
  job['chefspec']      = true
  job['serverspec']    = true
  job['junit_results'] = false
  job['command']       = "template_cookbook"
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
  job['command']       = "base"
end
