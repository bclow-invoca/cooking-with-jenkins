use_inline_resources if defined?(use_inline_resources)

# Support whyrun
def whyrun_supported?
  true
end

#
# create action
#
action :create do
  job_name = "cookbook-#{new_resource.name}"

  job_config = ::File.join(Chef::Config[:file_cache_path], "#{job_name}-config.xml")

  jenkins_job job_name do
    action :nothing
    config job_config
  end

  # FIXME; correct to match old setup; add override via attribute
  commands = ["bundle install --deployment"]
  commands << "bundle exec rake lint" if new_resource.foodcritic
  commands << "bundle exec rake spec" if new_resource.chefspec
  commands << "bundle exec rake kitchen:all" if new_resource.serverspec

  #  commands = ["bundle install --deployment"]
  #  commands << "bundle exec rake test:foodcritic" if new_resource.foodcritic
  #  commands << "bundle exec rake test:chefspec" if new_resource.chefspec
  #  commands << "bundle exec berks" if new_resource.serverspec
  #  commands << "bundle exec rake test:serverspec" if new_resource.serverspec

  template job_config do
    source 'cookbook-job.xml.erb'
    cookbook 'jenkins-ci'
    variables(
      :git_url => new_resource.repository,
      :git_branch => new_resource.branch,
      :commands => commands.join("\n"),
      :params => new_resource
    )
    notifies :create, "jenkins_job[#{job_name}]", :immediately
  end
end

#
# enable action
#
action :enable do
  job_name = "cookbook-#{new_resource.name}"
  notifies :enable, "jenkins_job[#{job_name}]", :immediately
end

#
# disable action
#
action :disable do
  job_name = "cookbook-#{new_resource.name}"
  notifies :disable, "jenkins_job[#{job_name}]", :immediately
end

#
# delete action
#
action :delete do
  job_name = "cookbook-#{new_resource.name}"
  notifies :delete, "jenkins_job[#{job_name}]", :immediately
end
