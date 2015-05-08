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
  repo = new_resource.repository

  job_config = File.join(Chef::Config[:file_cache_path], "#{job_name}-config.xml")

  jenkins_job job_name do
    action :nothing
    config job_config
  end

  commands = ["bundle install"]
  commands << "bundle exec rake test:foodcritic" if new_resource.foodcritic
  commands << "bundle exec rake test:chefspec" if new_resource.chefspec
  commands << "bundle exec berks" if new_resource.kitchen
  commands << "bundle exec rake test:serverspec" if new_resource.kitchen

  template job_config do
    source 'cookbook-job.xml.erb'
    cookbook 'jenkins-ci'
    variables(
      :git_url => new_resource.repo
      :git_branch => new_resource.branch
      :commands => commands.join("\n")
      :params => new_resource
    )
    notifies  :create, "jenkins_job[#{job_name}]", :immediately
  end
end

#
# create action
#
action :delete do
  job_name = "cookbook-#{new_resource.name}"
  notifies  :delete, "jenkins_job[#{job_name}]", :immediately
end

#
# create action
#
action :enable do
  job_name = "cookbook-#{new_resource.name}"
  notifies  :enable, "jenkins_job[#{job_name}]", :immediately
end

#
# create action
#
action :disable do
  job_name = "cookbook-#{new_resource.name}"
  notifies  :disable, "jenkins_job[#{job_name}]", :immediately
end
