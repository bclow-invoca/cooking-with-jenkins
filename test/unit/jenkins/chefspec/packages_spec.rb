#
# jenkins-ci::packages
#
require_relative 'spec_helper'

describe 'jenkins-ci::packages' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  %w(
    git::default
  ).each do |r|
    it "requires #{r}" do
      expect(chef_run).to include_recipe(r)
    end
  end
end
