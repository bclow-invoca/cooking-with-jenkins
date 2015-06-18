#
# Setting ruby/rbenv to not be installed by default
#
default['jenkins_ci']['rbenv']['install'] = false
default['jenkins_ci']['jenkins']['warnings_publisher'] = true
default['jenkins_ci']['jenkins']['custom_kitchen'] = true

#
# Determine what to install
#
case node['platform_family']
when 'debian'
  default['jenkins_ci']['ruby_packages']   = ['ruby1.9.3', 'rake', 'ruby-bundler', 'libxml2-dev', 'libxslt-dev']
when 'rhel'
  default['jenkins_ci']['ruby_packages']   = ['libxml2-devel', 'libxslt-devel']
  default['rbenv']['ruby_version'] = 'ruby-1.9.3'
  default['rbenv']['user_installs'] = [
    { 'user' => 'jenkins',
      'home' => '/var/lib/jenkins',
      'default_ruby' => 'ruby-1.9.3',
      'global_gems' => [
        { 'name' => 'kitchen-openstack' }
      ]
    }
  ]
end

default['jenkins_ci']['apache']['service_name'] = node['fqdn']

#
# data bag manipulation
#
default['jenkins_ci']['app_data_bag'] = 'jenkins'
default['jenkins_ci']['encrypted_item'] = node.chef_environment
default['jenkins_ci']['secrets_key_path'] =
  case node.chef_environment
  when 'test'
    '/tmp/kitchen/encrypted_data_bag_secret'
  else
    '/etc/chef/encrypted_data_bag_secret'
  end
