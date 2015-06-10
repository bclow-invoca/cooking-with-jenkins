require "spec_helper"

describe "jenkins-ci::default" do
  it "listens on port 8080" do
    expect(port(8080)).to be_listening
  end

  describe "displays the Jenkins home page on port 8080" do
    describe command('wget -q -O - http://localhost:8080/') do
      its(:stdout) { should match(/.*Jenkins.*/) }
    end
  end

  describe "installs git" do
    describe command('which git') do
      its(:stdout) { should match %r{.*/bin/git.*} }
    end
  end

  describe "installs the Jenkins git plugins" do
    %w(
      scm-api
      git
      git-client
    ).each do |p|
      search = "plugin/#{p}/uninstall"
      list_installed_plugins = "wget -q -O - http://localhost:8080/pluginManager/installed"
      describe command(list_installed_plugins) do
        its(:stdout) { should match(/.*#{Regexp.quote(search)}.*/) }
      end
    end
  end

  describe "creates a job for the memcached cookbook" do
    list_jobs = "wget -q -O - http://localhost:8080/view/All/"
    job_name = "cookbook-test"
    describe command(list_jobs) do
      its(:stdout) { should match(/.*#{Regexp.quote(job_name)}.*/) }
    end
  end
end
