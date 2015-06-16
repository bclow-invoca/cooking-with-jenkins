require "spec_helper"

describe "jenkins-ci::jobs" do
  describe "creates jobs for included cookbooks" do
    list_jobs = command('java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080/ list-jobs').stdout
    %w(
      cookbook-template_cookbook
      cookbook-test
    ).each do |job_name|
      it "has #{job_name} installed" do
        expect(list_jobs).to match(/.*#{Regexp.quote(job_name)}.*/)
      end
    end
  end
end
