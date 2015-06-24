#
# jenkins-ci::vagrant
#
require_relative 'spec_helper'

describe 'jenkins-ci::vagrant' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  context 'check defaults' do
    it 'sets vagrant version' do
      expect(chef_run.node['vagrant']['version']).to eql('1.7.2')
    end

    %w(
      vagrant
    ).each do |plugin|
      it "includes jenkins plugin #{plugin}" do
        expect(chef_run.node['jenkins_ci']['jenkins']['plugins']).to include(plugin)
      end
    end

    %w(
      berkshelf
      chef-zero
      omnibus
      vagrant-berkshelf
      vagrant-cachier
      vagrant-chef-zero
      vagrant-omnibus
    ).each do |plugin|
      it "includes the vagrant #{plugin}" do
        expect(chef_run.node['vagrant']['plugins']).to include(plugin)
      end
    end
  end

  %w(
    vagrant::default
  ).each do |r|
    it "requires #{r}" do
      expect(chef_run).to include_recipe(r)
    end
  end
end
