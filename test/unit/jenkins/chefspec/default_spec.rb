#
# jenkins-ci::default
#
require_relative 'spec_helper'

describe 'jenkins-ci::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

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
