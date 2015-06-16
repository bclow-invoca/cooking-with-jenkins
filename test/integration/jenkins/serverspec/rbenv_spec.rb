require "spec_helper"

describe "jenkins-ci::rbenv" do
  describe "installs rbenv" do
    describe file('/opt/rbenv') do
      it { should be_directory }
      it { should be_readable.by_user('jenkins') }
      it { should be_writable.by_user('rbenv') }
      it { should be_executable.by_user('jenkins') }
      it { should be_owned_by 'rbenv' }
      it { should be_grouped_into 'rbenv' }
    end
    print_env = command('sudo -u jenkins -i printenv').stdout.chomp
    it "has RBENV_ROOT set to /opt/rbenv" do
      expect(print_env).to match %r{RBENV_ROOT=/opt/rbenv}
    end
    which_rbenv = command('sudo -u jenkins -i which rbenv').stdout.chomp
    it "has rbenv in search path" do
      expect(which_rbenv).to match %r{/opt/rbenv/bin/rbenv}
    end
    describe file(which_rbenv) do
      it { should be_linked_to '../libexec/rbenv' }
      it { should be_owned_by 'rbenv' }
      it { should be_grouped_into 'rbenv' }
    end
    describe file('/opt/rbenv/libexec/rbenv') do
      it { should be_file }
      it { should be_mode 755 }
      it { should be_owned_by 'rbenv' }
      it { should be_grouped_into 'rbenv' }
    end
  end

  %w(
    1.9.3-p484
    2.1.2
  ).each do |ruby|
    describe ruby do
      describe file("/opt/rbenv/versions/#{ruby}") do
        it { should be_directory }
        it { should be_readable.by_user('jenkins') }
        it { should be_writable.by_user('rbenv') }
        it { should be_executable.by_user('jenkins') }
        it { should be_owned_by 'rbenv' }
        it { should be_grouped_into 'rbenv' }
      end
      describe file("/opt/rbenv/versions/#{ruby}/bin/ruby") do
        it { should be_file }
        it { should be_mode 775 }
        it { should be_owned_by 'rbenv' }
        it { should be_grouped_into 'rbenv' }
      end
      version_name = command("RBENV_VERSION=#{ruby} /opt/rbenv/bin/rbenv version-name").stdout
      it "RBENV_VERSION=#{ruby} /opt/rbenv/bin/rbenv version-name" do
        expect(version_name).to match(/#{ruby}/)
      end
      which_ruby = command("sudo -u jenkins -i RBENV_VERSION=#{ruby} which ruby").stdout.chomp
      it "sudo -u jenkins -i RBENV_VERSION=#{ruby} which ruby" do
        expect(which_ruby).to match %r{/opt/rbenv/shims/ruby}
      end
      describe file(which_ruby) do
        it { should be_file }
        it { should be_mode 755 }
        it { should be_owned_by 'rbenv' }
        it { should be_grouped_into 'rbenv' }
      end
      ruby_version = command("sudo -u jenkins -i RBENV_VERSION=#{ruby} ruby -v").stdout
      it "sudo -u jenkins -i RBENV_VERSION=#{ruby} ruby -v" do
        ruby_ = ruby.sub('-', '')
        expect(ruby_version).to match(/ruby #{ruby_}/)
      end
      which_gem = command("sudo -u jenkins -i RBENV_VERSION=#{ruby} which gem").stdout.chomp
      it "sudo -u jenkins -i RBENV_VERSION=#{ruby} which gem" do
        expect(which_gem).to match %r{/opt/rbenv/shims/gem}
      end
      describe file(which_gem) do
        it { should be_file }
        it { should be_mode 755 }
        it { should be_owned_by 'rbenv' }
        it { should be_grouped_into 'rbenv' }
      end
      gem_list = command("sudo -u jenkins -i RBENV_VERSION=#{ruby} gem list").stdout
      it "sudo -u jenkins -i RBENV_VERSION=#{ruby} gem list" do
        expect(gem_list).to match(/bundler/)
      end
      which_bundle = command("sudo -u jenkins -i RBENV_VERSION=#{ruby} which bundle").stdout.chomp
      it "sudo -u jenkins -i RBENV_VERSION=#{ruby} which bundle" do
        expect(which_bundle).to match %r{/opt/rbenv/shims/bundle}
      end
      describe file(which_bundle) do
        it { should be_file }
        it { should be_mode 755 }
        it { should be_owned_by 'rbenv' }
        it { should be_grouped_into 'rbenv' }
      end
    end
  end
end
