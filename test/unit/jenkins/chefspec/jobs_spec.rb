#
# jenkins-ci::jobs
#
require_relative 'spec_helper'

describe 'jenkins-ci::jobs' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      env = Chef::Environment.new
      env.name 'test'

      allow(node).to receive(:chef_environment).and_return(env.name)
      allow(Chef::Environment).to receive(:load).and_return(env)
    end.converge(described_recipe)
  end

  cookbooks = {
    'managed_directory' => ['https://github.com/zts/chef-cookbook-managed_directory.git', 'master', true, true, true, true],
    'mcollective' => ['https://github.com/zts/cookbook-mcollective.git', 'master', true, false, true, false],
    'test' => ['https://github.com/zts/test-cookbook.git', 'master', true, true, false, true],
  }

  cookbooks.each do |cb, tests|
    it "creates testing framework for #{cb}" do
      expect(chef_run).to create_cookbook_ci(cb).with(
        repository: tests[0],
        branch: tests[1],
        foodcritic: tests[2],
        chefspec: tests[3],
        serverspec: tests[4],
        junit_results: tests[5]
      )
    end
  end
end
