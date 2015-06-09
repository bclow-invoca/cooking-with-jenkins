node.set['jenkins-ci']['rbenv']['version'] = ['1.9.3-p448', '2.1.2']
include_recipe 'rbenv::default'
include_recipe 'rbenv::ruby_build'
include_recipe 'rbenv::rbenv_vars'

node['jenkins-ci']['rbenv']['version'].each do |ruby|
  rbenv_ruby ruby do
    action :install
    global true
  end

  rbenv_gem 'bundler' do
    ruby_version ruby
  end
end
