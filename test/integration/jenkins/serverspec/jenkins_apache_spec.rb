require_relative 'spec_helper'

#
# jenkins-ci::apache
#
describe 'jenkins-ci::apache' do
  describe file('/etc/apache2/ssl') do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  %w(
    jenkins_cert.pem
    jenkins_key.pem
  ).each do |cert_file|
    describe file("/etc/apache2/ssl/#{cert_file}") do
      it { should be_file }
      it { should be_mode 600 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should contain(/BEGIN/) }
      it { should contain(/END/) }
    end
  end

  %w(
    jenkins-ci.conf
  ).each do |site|
    describe file("/etc/apache2/sites-available/#{site}") do
      it { should be_file }
      it { should be_mode 644 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should contain(/IfModule mod_ssl.c/) }
      it { should contain(/ProxyPreserveHost On/) }
      it { should contain(/jenkins/) }
    end
    describe file("/etc/apache2/sites-enabled/#{site}") do
      it { should be_linked_to "../sites-available/#{site}" }
    end
  end

  describe file('/etc/apache2/sites-available/jenkins-ci.conf') do
    it { should contain(/jenkins/) }
  end

  describe file('/etc/apache2/conf-available/fqdn.conf') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should contain(/jenkins/) }
  end

  describe file('/etc/apache2/conf-enabled/fqdn.conf') do
    it { should be_linked_to '../conf-available/fqdn.conf' }
  end
end
