require "spec_helper"

describe "jenkins_ci::jenkins" do
  describe "displays the Jenkins home page on port 8080" do
    describe service('jenkins') do
      it { should be_enabled }
      it { should be_running }
    end
    it "listens on port 8080" do
      expect(port(8080)).to be_listening
    end
    index_page = command('wget -q -O - http://localhost:8080/').stdout
    it "responds with 'Jenkins'" do
      expect(index_page).to match(/.*Jenkins.*/)
    end
  end

  describe "jenkins cli exists" do
    describe file('/var/cache/jenkins/war/WEB-INF/jenkins-cli.jar') do
      it { should be_file }
      it { should be_mode 644 }
      it { should be_owned_by 'jenkins' }
      it { should be_grouped_into 'jenkins' }
    end
  end

  describe "installs the Jenkins git plugins" do
    list_installed_plugins = command('java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080/ list-plugins').stdout
    %w(
      ansicolor
      ant
      build-pipeline-plugin
      buildresult-trigger
      durable-task
      email-ext
      embeddable-build-status
      ez-templates
      git
      git-client
      git-server
      github
      github-api
      github-oauth
      javadoc
      jenkinswalldisplay
      matrix-auth
      maven-plugin
      pollscm
      promoted-builds
      promoted-builds-simple
      scm-api
      token-macro
    ).each do |plugin|
      it "has #{plugin} plugin installed" do
        expect(list_installed_plugins).to match(/.*#{Regexp.quote(plugin)}.*/)
      end
    end
  end

  describe file('/var/lib/jenkins/hudson.plugins.warnings.WarningsPublisher.xml') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'jenkins' }
    it { should be_grouped_into 'jenkins' }
    it { should contain(/WarningsDescriptor/) }
  end

  describe file('/var/lib/jenkins/custom-config-files.xml') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'jenkins' }
    it { should be_grouped_into 'jenkins' }
    it { should contain(/name: docker/) }
  end
end
