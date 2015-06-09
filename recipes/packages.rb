#
# Cookbook Name:: jenkins-ci
# Recipe:: install
#
# installs packages required for CI testing of cookbooks
#
# Copyright (C) 2013 Zachary Stevens
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# First, make sure apt-update gets run
case node['platform_family']
when 'debian'
  include_recipe 'apt'
when 'rhel'
  include_recipe 'yum'
else
  fail "'#{node['platform_family']}' is not supported!"
end

# We'll be pulling code using git
include_recipe 'git::default'

if node['jenkins_ci']['rbenv']['install']
  # We'll need a ruby to run cookbook tests, and some of the gems we'll
  # be installing need a few dev packages installed
  node['jenkins_ci']['ruby_packages'].each { |p| package p }

  include_recipe 'rbenv::user'

  if node['jenkins_ci'].key? 'gem_packages'
    node['jenkins_ci']['gem_packages'].each { |p| gem_package p }
  end
end
