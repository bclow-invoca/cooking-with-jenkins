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

  commands = []
  if new_resource.custom_command
    commands = [*node['jenkins_ci']['jenkins']['command']['override']['custom']]
  else
    node['jenkins_ci']['jenkins']['command'][new_resource.command].tap do |command|
      commands << [*command['base']]
      commands << [*command['foodcritic']] if new_resource.foodcritic
      commands << [*command['chefspec']] if new_resource.chefspec
      commands << [*command['serverspec']] if new_resource.serverspec
    end
  end

  template job_config do
    source 'cookbook-job.xml.erb'
    cookbook 'jenkins_ci'
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
