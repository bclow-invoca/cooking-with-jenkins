#
# constants
#
CHEF_VERSION = '11.16.4'

#
# common tasks
#
desc "run all tests"
task :test => ['test:foodcritic', 'test:rubocop', 'test:chefspec', 'test:library', 'test:serverspec'] do
  puts "Tests complete!"
end

namespace :test do
  desc "run foodcritic lint"
  task :foodcritic do
    sh "bundle exec foodcritic --chef-version #{CHEF_VERSION} --tags ~FC003 -f correctness ."
  end

  desc "run rubocop lint"
  task :rubocop do
    sh "bundle exec rubocop --format simple"
  end

  desc "run chefspec tests"
  task :chefspec do
    sh "bundle exec rspec --color -fd test/unit/jenkins/chefspec/*_spec.rb"
  end

  desc "run library spec tests"
  task :library do
    sh "bundle exec rspec --color -fd test/unit/libraries/rspec/*_spec.rb"
  end

  desc "run serverspec tests"
  task :serverspec do
    sh "bundle exec kitchen test"
  end
end
