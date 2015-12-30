require_relative 'spec_helper'

#
# apache
#
describe 'apache2::default' do
  describe package('apache2') do
    it { should be_installed }
  end

  describe group('www-data') do
    it { should exist }
  end

  describe user('www-data') do
    it { should exist }
    it { should belong_to_group 'www-data' }
  end

  describe service('apache2') do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/etc/apache2') do
    it { should be_directory }
    it { should be_mode 755 }
  end

  %w(
    conf-available
    conf-enabled
    mods-available
    mods-enabled
    sites-available
    sites-enabled
  ).each do |dir|
    describe file("/etc/apache2/#{dir}") do
      it { should be_directory }
      it { should be_mode 755 }
    end
  end

  describe file('/var/log/apache2') do
    it { should be_directory }
    it { should be_mode 755 }
  end

  describe file('/usr/lib/apache2') do
    it { should be_directory }
    it { should be_mode 755 }
  end

  describe file('/etc/apache2/sites-enabled/000-default') do
    it { should_not be_file }
    it { should_not be_symlink }
  end

  %w(
    a2disconf
    a2dismod
    a2dissite
    a2enconf
    a2enmod
    a2ensite
  ).each do |mod_script|
    describe file("/usr/sbin/#{mod_script}") do
      it { should be_file }
      it { should be_executable }
    end
  end

  %w(
    80
    443
  ).each do |prt|
    describe port(prt) do
      if os[:release] == '12.04'
        it { should be_listening.with('tcp') }
      else
        it { should be_listening.with('tcp6') }
      end
    end
  end

  describe file('/etc/apache2/ports.conf') do
    it { should contain(/^Listen .*[: ]80$/) }
    it { should contain(/^Listen .*[: ]443$/) }
  end

  describe command("APACHE_LOG_DIR=/var/log/apache2 /usr/sbin/apache2 -t") do
    its(:exit_status) { should eq 0 }
  end
end
