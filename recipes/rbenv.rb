node.set['jenkins_ci']['rbenv']['install'] = true
node.set['jenkins_ci']['jenkins']['plugins'] = [] unless node['jenkins_ci']['jenkins']['plugins']
node.set['jenkins_ci']['jenkins']['plugins'] = node['jenkins_ci']['jenkins']['plugins'] + ['ruby-runtime', 'rbenv']
node.set['jenkins_ci']['rbenv']['version'] = ['2.1.2', '2.1.9']
include_recipe 'rbenv::default'
include_recipe 'rbenv::ruby_build'
include_recipe 'rbenv::rbenv_vars'

node['jenkins_ci']['rbenv']['version'].each do |ruby|
  rbenv_ruby ruby do
    action :install
    global true
  end

  rbenv_gem 'bundler' do
    version '1.12.5'
    ruby_version ruby
  end
end
