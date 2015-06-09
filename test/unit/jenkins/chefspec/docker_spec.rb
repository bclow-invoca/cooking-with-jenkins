#
# jenkins-ci::docker
#
require_relative 'spec_helper'

describe 'jenkins-ci::docker' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      env = Chef::Environment.new
      env.name 'test'

      allow(node).to receive(:chef_environment).and_return(env.name)
      allow(Chef::Environment).to receive(:load).and_return(env)
    end.converge(described_recipe)
  end

  %w(
    docker::default
  ).each do |r|
    it "requires #{r}" do
      expect(chef_run).to include_recipe(r)
    end
  end

  it 'adds jenkins to docker group' do
    expect(chef_run).to modify_group('docker')
    expect(chef_run.group('docker').members).to include('jenkins')

    group_notify = chef_run.group('docker')
    expect(group_notify).to notify('service[docker]').to(:restart)
  end

  %w(
    centos
    ubuntu
  ).each do |img|
    it "pulls os #{img}" do
      expect(chef_run).to pull_docker_image(img)
    end
  end
end
