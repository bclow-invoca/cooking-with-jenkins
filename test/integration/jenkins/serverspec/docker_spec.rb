require "spec_helper"

describe "jenkins-ci::docker" do
  describe "docker is running" do
    describe service('docker') do
      it { should be_enabled }
      it { should be_running }
    end
    docker_info = command("docker info").stdout
    it "docker info" do
      expect(docker_info).to match(/Storage Driver: aufs/)
    end
    docker_images = command("docker images").stdout
    %w(
      centos
      ubuntu
    ).each do |image|
      it "has #{image} image installed" do
        expect(docker_images).to match(/#{image}/)
      end
    end
  end

  describe user('jenkins') do
    it { should belong_to_group 'docker' }
  end
end
