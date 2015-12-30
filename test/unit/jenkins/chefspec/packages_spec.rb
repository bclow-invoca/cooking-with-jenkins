#
# jenkins_ci::packages
#
require_relative 'spec_helper'

describe 'jenkins_ci::packages' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  %w(
    git::default
  ).each do |r|
    it "requires #{r}" do
      expect(chef_run).to include_recipe(r)
    end
  end
end
