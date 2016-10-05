#
# constants
#
concurrency = ENV['CONCURRENT'] || 1
CHEF_VERSION = '12.11.18'.freeze

#
# common tasks
#
desc 'run all tests'
task :test => ['test:foodcritic', 'test:rubocop', 'test:chefspec', 'test:library', 'test:serverspec'] do
  puts 'Tests complete!'
end

namespace :test do
  desc 'run foodcritic lint'
  task :foodcritic do
    sh "bundle exec foodcritic --chef-version #{CHEF_VERSION} --tags ~FC003 -f correctness ."
  end

  desc 'run rubocop lint'
  task :rubocop do
    sh 'bundle exec rubocop --format simple'
  end

  desc 'run chefspec tests'
  task :chefspec do
    sh 'bundle exec rspec --color -fd test/unit/jenkins/chefspec/*_spec.rb'
  end

  desc 'run library spec tests'
  task :library do
    sh 'bundle exec rspec --color -fd test/unit/libraries/rspec/*_spec.rb'
  end

  desc 'run serverspec tests'
  task :serverspec do
    sh "bundle exec kitchen test -c #{concurrency}"
  end
end

#
# cookbook management
#
namespace :cookbook do
  desc 'upload cookbook to opscode'
  task :upload do
    sh 'bundle exec berks upload --no-freeze'
  end

  desc 'release cookbook'
  task :release do
    version = `grep ^version metadata.rb`.split.last.delete("'")

    unless `grep #{version} CHANGES`
      raise "CHANGES file does not contain version #{version}"
    end

    sh 'git fetch --tags'
    sh "git tag v#{version} --force"
    sh 'git push --tags --force'
    sh 'bundle exec berks upload'
  end

  task :berks do
    berks_path = File.expand_path('.berkshelf')
    sh "BERKSHELF_PATH=#{berks_path} SOLVE_TIMEOUT=10000 bundle exec berks"
  end

  task :berks_vendor do
    berks_path = File.expand_path('.berkshelf')
    sh "BERKSHELF_PATH=#{berks_path} SOLVE_TIMEOUT=10000 bundle exec berks vendor"
  end
end
