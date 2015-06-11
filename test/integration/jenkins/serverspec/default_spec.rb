require "spec_helper"

# FIXME; Jenkins restarts at end of converge,
# FIXME; this does not allow enough time for it to start before these tests run
# FIXME; This is a crappy solution, but it works for the moment.
sleep(30)

describe "jenkins-ci::default" do
  describe "displays the Jenkins home page on port 8080" do
    it "listens on port 8080" do
      expect(port(8080)).to be_listening
    end
    index_page = command('wget -q -O - http://localhost:8080/').stdout
    it "responds with 'Jenkins'" do
      expect(index_page).to match(/.*Jenkins.*/)
    end
  end

  describe "installs git" do
    which_git = command('which git').stdout.chomp
    it "has git in search path" do
      expect(which_git).to match %r{.*/bin/git.*}
    end
    describe file(which_git) do
      it { should be_file }
      it { should be_mode 755 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
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
      analysis-core
      ansicolor
      ant
      dashboard-view
      git
      git-client
      github
      github-api
      github-oauth
      javadoc
      maven-plugin
      rbenv
      ruby-runtime
      scm-api
      token-macro
      violations
      warnings
    ).each do |plugin|
      it "has #{plugin} plugin installed" do
        expect(list_installed_plugins).to match(/.*#{Regexp.quote(plugin)}.*/)
      end
    end
  end

  describe "creates a job for the memcached cookbook" do
    list_jobs = command('java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080/ list-jobs').stdout
    %w(
      cookbook-managed_directory
      cookbook-mcollective
      cookbook-test
    ).each do |job_name|
      it "has #{job_name} installed" do
        expect(list_jobs).to match(/.*#{Regexp.quote(job_name)}.*/)
      end
    end
  end
end
