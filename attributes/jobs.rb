# Rotation
node['jenkins_ci']['jenkins']['rotation']['enabled']                 = false
node['jenkins_ci']['jenkins']['rotation']['days_to_keep']            = -1
node['jenkins_ci']['jenkins']['rotation']['number_to_keep']          = -1
node['jenkins_ci']['jenkins']['rotation']['days_to_keep_artifact']   = -1
node['jenkins_ci']['jenkins']['rotation']['number_to_keep_artifact'] = -1

# Email notify options
default['jenkins_ci']['jenkins']['email_notify']['enabled'] = false
default['jenkins_ci']['jenkins']['email_notify']['options'].tap do |option|
  option['attach_build_log']   = false
  option['compress_build_log'] = false
end

# Slack notify options
default['jenkins_ci']['jenkins']['slack_notify']['enabled'] = false
default['jenkins_ci']['jenkins']['slack_notify']['options'].tap do |option|
  option['notify_start']             = false
  option['nofity_success']           = true
  option['notify_aborted']           = false
  option['notify_not_built']         = false
  option['notify_unstable']          = false
  option['notify_failure']           = true
  option['nofity_back_to_normal']    = false
  option['notify_repeated_failure']  = false
  option['include_test_summary']     = false
  option['show_commit_list']         = false
  option['include_custom_message']   = false
  option['custom_message']           = ''
  option['team_domain']              = 'organization'
  # FIXME; hard coded, which is a bad, bad admin
  option['token']                    = 'agF11LK6r4MLSwpj9tka7Cb9'
end

# Credentials
default['jenkins_ci']['jenkins']['credentials']['git'] = 'somehash'

# Triggers
default['jenkins_ci']['jenkins']['git_triggers']['enabled'] = false
default['jenkins_ci']['jenkins']['git_triggers']['spec']    = 'H * * * *'

# Cookbook commands
default['jenkins_ci']['jenkins']['command']['override']['enabled'] = false
default['jenkins_ci']['jenkins']['command']['override']['custom']  = false
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
