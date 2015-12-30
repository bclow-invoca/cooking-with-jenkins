#
# jenkins_ci::default
#
require_relative 'spec_helper'

describe 'jenkins_ci::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  %w(
    jenkins_ci::packages
    jenkins_ci::docker
    jenkins_ci::jenkins
    jenkins_ci::jobs
  ).each do |r|
    it "requires #{r}" do
      expect(chef_run).to include_recipe(r)
    end
  end
end
