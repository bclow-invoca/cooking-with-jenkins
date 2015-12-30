node.set['jenkins_ci']['jenkins']['plugins'] = [] unless node['jenkins_ci']['jenkins']['plugins']
node.set['jenkins_ci']['jenkins']['plugins'] = node['jenkins_ci']['jenkins']['plugins'] + ['virtualbox']
include_recipe 'virtualbox::default'
