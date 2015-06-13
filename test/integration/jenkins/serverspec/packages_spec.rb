require "spec_helper"

describe "jenkins-ci::packages" do
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

  if os[:family] == 'redhat'
    describe "installs yum" do
      which_apt = command('which yum').stdout.chomp
      it "has yum in search path" do
        expect(which_yum).to match %r{.*/bin/yum.*}
      end
      describe file(which_yum) do
        it { should be_file }
        it { should be_mode 755 }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
      end
    end
  elsif ['debian', 'ubuntu'].include?(os[:family])
    describe "installs apt" do
      which_apt = command('which apt').stdout.chomp
      it "has apt in search path" do
        expect(which_apt).to match %r{.*/bin/apt.*}
      end
      describe file(which_apt) do
        it { should be_file }
        it { should be_mode 755 }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
      end
    end
  end
end
