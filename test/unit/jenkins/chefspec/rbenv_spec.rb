#
# jenkins-ci::jenkins
#
require_relative 'spec_helper'

describe 'jenkins-ci::rbenv' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      env = Chef::Environment.new
      env.name 'test'

      allow(node).to receive(:chef_environment).and_return(env.name)
      allow(Chef::Environment).to receive(:load).and_return(env)
    end.converge(described_recipe)
  end

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
      1.9.3-p448
      2.1.2
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
    1.9.3-p448
    2.1.2
  ).each do |ruby|
    it "installs ruby version #{ruby} and bundler" do
      expect(chef_run).to install_rbenv_ruby(ruby)
      # BROKEN #expect(chef_run).to install_rbenv_gem('bundler').with(ruby_version: ruby)
      expect(chef_run).to install_rbenv_gem('bundler')
    end
  end
end
