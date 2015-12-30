#
# Cookbook Name:: jenkins_ci
# Recipe:: default
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

# Install support packages and framework
include_recipe "jenkins_ci::packages"

# Prepare jenkins for running jobs
include_recipe "jenkins_ci::jenkins"

# Prepare docker for use under jenkins
include_recipe "jenkins_ci::docker"

# Create jobs for the cookbooks we're testing
include_recipe "jenkins_ci::jobs"
