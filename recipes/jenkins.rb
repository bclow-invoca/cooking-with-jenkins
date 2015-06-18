#
# Cookbook Name:: jenkins-ci
# Recipe:: configure-jenkins
#
# Adds plugins and common configuration we'll rely on in our Jenkins
# job definitions.
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

include_recipe 'jenkins::master'

# unique plugins array before processing it
node.set['jenkins_ci']['jenkins']['plugins'] = node['jenkins_ci']['jenkins']['plugins'].uniq.sort
node['jenkins_ci']['jenkins']['plugins'].each do |plugin|
  Chef::Log.info("---------------------------------> Installing plugin #{plugin} <---------------------------------")
  jenkins_plugin plugin do
    install_deps true
    notifies :restart, 'service[jenkins]', :delayed
  end
end

cookbook_file "#{node['jenkins']['master']['home']}/hudson.plugins.warnings.WarningsPublisher.xml" do
  owner "jenkins"
  group "jenkins"
  mode "0644"
  notifies :restart, "service[jenkins]", :delayed
  only_if { node['jenkins_ci']['jenkins']['warnings_publisher'] == true }
end

# This plugin lets us define static files which can (optionally) be
# installed into a job's workspace before running any commands.  We
# use it to override the test-kitchen configuration to use docker
# instead of vagrant.
cookbook_file "#{node['jenkins']['master']['home']}/custom-config-files.xml" do
  owner "jenkins"
  group "jenkins"
  mode "0644"
  notifies :restart, "service[jenkins]", :delayed
  only_if { node['jenkins_ci']['jenkins']['custom_kitchen'] == true }
end
