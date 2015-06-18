#
# jenkins-ci::jenkins
#
require_relative 'spec_helper'

describe 'jenkins-ci::jenkins' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  let(:chef_run_no_custom) do
    ChefSpec::Runner.new do |node|
      env = Chef::Environment.new
      env.name 'test'

      node.set['jenkins_ci']['jenkins']['warnings_publisher'] = false
      node.set['jenkins_ci']['jenkins']['custom_kitchen'] = false

      allow(node).to receive(:chef_environment).and_return(env.name)
      allow(Chef::Environment).to receive(:load).and_return(env)
    end.converge(described_recipe)
  end

  %w(
    jenkins::master
  ).each do |r|
    it "requires #{r}" do
      expect(chef_run).to include_recipe(r)
    end
  end

  %w(
    analysis-core
    ansicolor
    ant
    config-file-provider
    dashboard-view
    git
    git-client
    github
    github-api
    github-oauth
    javadoc
    maven-plugin
    scm-api
    token-macro
    violations
    warnings
  ).each do |plugin|
    it "install jenkins plugin #{plugin}" do
      expect(chef_run).to install_jenkins_plugin(plugin)
    end
  end

  let(:hudson_xml) { '/var/lib/jenkins/hudson.plugins.warnings.WarningsPublisher.xml' }
  let(:custom_config) { '/var/lib/jenkins/custom-config-files.xml' }
  describe "customizations enabled" do
    it 'installs jenkins file hudson.plugins.warnings.WarningsPublisher.xml' do
      expect(chef_run).to create_cookbook_file(hudson_xml).with(
        owner: 'jenkins',
        group: 'jenkins',
        mode: '0644'
      )
      file_notify = chef_run.cookbook_file(hudson_xml)
      expect(file_notify).to notify('service[jenkins]').to(:restart)
    end
    it 'installs custom config to override test kitchen' do
      expect(chef_run).to create_cookbook_file(custom_config).with(
        owner: 'jenkins',
        group: 'jenkins',
        mode: '0644'
      )
      file_notify = chef_run.cookbook_file(custom_config)
      expect(file_notify).to notify('service[jenkins]').to(:restart)
    end
  end

  describe "customizations disabled" do
    it 'does not install jenkins file hudson.plugins.warnings.WarningsPublisher.xml' do
      expect(chef_run_no_custom).to_not create_cookbook_file(hudson_xml)
    end
    it 'does not install custom config to override test kitchen' do
      expect(chef_run_no_custom).to_not create_cookbook_file(custom_config)
    end
  end
end
