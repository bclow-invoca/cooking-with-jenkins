#
# jenkins_ci::docker
#
require_relative 'spec_helper'

describe 'jenkins_ci::docker' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'adds jenkins to docker group' do
    expect(chef_run).to modify_group('docker')
    expect(chef_run.group('docker').members).to include('jenkins')

    # group_notify = chef_run.group('docker')
    # expect(group_notify).to notify('service[docker]').to(:restart)
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
