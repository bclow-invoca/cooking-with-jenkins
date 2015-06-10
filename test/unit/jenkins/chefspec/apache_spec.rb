#
# jenkins-ci::apache
#
require_relative 'spec_helper'

apache_usr = 'root'
apache_grp = 'root'

describe 'jenkins-ci::apache' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      env = Chef::Environment.new
      env.name 'test'

      node.set['jenkins_ci']['secrets_key_path'] = 'test/data/secret.txt'

      allow(node).to receive(:chef_environment).and_return(env.name)
      allow(Chef::Environment).to receive(:load).and_return(env)
    end.converge(described_recipe)
  end

  before :each do
    stub_command("/usr/sbin/apache2 -t").and_return(true)

    allow(Chef::DataBagItem).to receive(:load).with('jenkins', anything)
      .and_return(JSON.parse(File.read('data_bags/jenkins/test.json')))
  end

  context 'check defaults' do
    it 'sets ssl cert paths to known locations' do
      expect(chef_run.node['jenkins_ci']['apache']['ssl_cert_dir']).to eql('/etc/apache2/ssl')
      expect(chef_run.node['jenkins_ci']['apache']['ssl_cert_path']).to eql('/etc/apache2/ssl/jenkins_cert.pem')
      expect(chef_run.node['jenkins_ci']['apache']['ssl_key_path']).to eql('/etc/apache2/ssl/jenkins_key.pem')
    end

    it 'sets apache to listen' do
      expect(chef_run.node['apache']['listen_ports']).to include('80')
      expect(chef_run.node['apache']['listen_ports']).to include('443')
    end

    it "creates site file with FQDN" do
      expect(chef_run).to create_file('/etc/apache2/conf-available/fqdn.conf').with(
        :user => apache_usr,
        :group => apache_grp,
        :mode => 00644
      )
      expect(chef_run).to render_file('/etc/apache2/conf-available/fqdn.conf').with_content("fauxhai.local")
    end
  end

  context 'ssl cert deployment' do
    it 'creates cert directory /etc/apache2/ssl' do
      expect(chef_run).to create_directory("/etc/apache2/ssl").with(
        :user => apache_usr,
        :group => apache_grp,
        :mode => 00755
      )
    end

    ['jenkins_cert.pem', 'jenkins_key.pem'].each do |ssl_file|
      it "creates file /etc/apache2/ssl/#{ssl_file}" do
        expect(chef_run).to create_file("/etc/apache2/ssl/#{ssl_file}").with(
          :user => apache_usr,
          :group => apache_grp,
          :mode => 00600
        )
        expect(chef_run).to render_file("/etc/apache2/ssl/#{ssl_file}").with_content("BEGIN")
      end
      it "notifies apache of file /etc/apache2/ssl/#{ssl_file}" do
        resource = chef_run.file("/etc/apache2/ssl/#{ssl_file}")
        expect(resource).to notify('service[apache2]').to(:restart).delayed
      end
    end
  end

  context 'site deployment' do
    ['jenkins-ci.conf'].each do |site|
      it "creates site file /etc/apache2/sites-available/#{site} from template" do
        expect(chef_run).to create_template("/etc/apache2/sites-available/#{site}").with(
          :user => apache_usr,
          :group => apache_grp,
          :mode => 00644
        )
      end
    end
  end

  %w(
    apache2::default
    apache2::mod_rewrite
    apache2::mod_headers
    apache2::mod_ssl
    apache2::mod_proxy
    apache2::mod_proxy_http
    apache2::logrotate
  ).each do |r|
    it "requires #{r}" do
      expect(chef_run).to include_recipe(r)
    end
  end
end
