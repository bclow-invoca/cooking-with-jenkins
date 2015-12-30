require "spec_helper"

describe "jenkins_ci::docker" do
  describe "docker is running" do
    describe service('docker') do
      it { should be_enabled }
      it { should be_running }
    end
    docker_info = command("docker info").stdout
    it "docker info" do
      if ['debian', 'ubuntu'].include?(os[:family])
        expect(docker_info).to match(/Storage Driver: aufs/)
      elsif os[:family] == 'redhat'
        expect(docker_info).to match(/Storage Driver: devicemapper/)
      end
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
