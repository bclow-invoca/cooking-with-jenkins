#
# jenkins-ci::jobs
#
require_relative 'spec_helper'

describe 'jenkins-ci::jobs' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  cookbooks = {
    'template_cookbook' => ['https://github.com/bclow-invoca/template-cookbook.git', 'master', true, true, true, false, 'template_cookbook'],
    'test' => ['https://github.com/zts/test-cookbook.git', 'master', true, true, false, true, 'base'],
  }

  cookbooks.each do |cb, tests|
    it "creates testing framework for #{cb}" do
      expect(chef_run).to create_cookbook_ci(cb).with(
        repository: tests[0],
        branch: tests[1],
        foodcritic: tests[2],
        chefspec: tests[3],
        serverspec: tests[4],
        junit_results: tests[5],
        command: tests[6]
      )
    end
  end
end
