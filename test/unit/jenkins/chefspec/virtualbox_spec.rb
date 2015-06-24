#
# jenkins-ci::virtualbox
#
require_relative 'spec_helper'

describe 'jenkins-ci::virtualbox' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  context 'check defaults' do
    %w(
      virtualbox
    ).each do |plugin|
      it "includes jenkins plugin #{plugin}" do
        expect(chef_run.node['jenkins_ci']['jenkins']['plugins']).to include(plugin)
      end
    end
  end

  %w(
    virtualbox::default
  ).each do |r|
    it "requires #{r}" do
      expect(chef_run).to include_recipe(r)
    end
  end
end
