#
# jenkins_ci::jenkins
#
require_relative 'spec_helper'

describe 'jenkins_ci::rbenv' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  context 'check defaults' do
    it 'sets node attribute rbenv install to true' do
      expect(chef_run.node['jenkins_ci']['rbenv']['install']).to eql(true)
    end

    %w(
      rbenv
      ruby-runtime
    ).each do |plugin|
      it "includes jenkins plugin #{plugin}" do
        expect(chef_run.node['jenkins_ci']['jenkins']['plugins']).to include(plugin)
      end
    end

    %w(
      2.1.2
      2.1.9
      2.2.2
    ).each do |ruby|
      it "includes ruby version #{ruby}" do
        expect(chef_run.node['jenkins_ci']['rbenv']['version']).to include(ruby)
      end
    end
  end

  %w(
    rbenv::default
    rbenv::ruby_build
    rbenv::rbenv_vars
  ).each do |r|
    it "requires #{r}" do
      expect(chef_run).to include_recipe(r)
    end
  end

  %w(
    2.1.2
    2.1.9
    2.2.2
  ).each do |ruby|
    it "installs ruby version #{ruby} and bundler" do
      expect(chef_run).to install_rbenv_ruby(ruby)
      # BROKEN #expect(chef_run).to install_rbenv_gem('bundler').with(ruby_version: ruby)
      expect(chef_run).to install_rbenv_gem('bundler').with(version: '1.12.5')
    end
  end
end
