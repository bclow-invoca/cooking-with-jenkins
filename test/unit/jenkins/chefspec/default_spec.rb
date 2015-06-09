#
# jenkins-ci::default
#
require_relative 'spec_helper'

describe 'jenkins-ci::default' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      env = Chef::Environment.new
      env.name 'test'

      allow(node).to receive(:chef_environment).and_return(env.name)
      allow(Chef::Environment).to receive(:load).and_return(env)
    end.converge(described_recipe)
  end

  %w(
    jenkins-ci::packages
    jenkins-ci::docker
    jenkins-ci::jenkins
    jenkins-ci::jobs
  ).each do |r|
    it "requires #{r}" do
      expect(chef_run).to include_recipe(r)
    end
  end
end
