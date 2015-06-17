#
# custom matchers
#
if defined?(ChefSpec)
  def install_rbenv_ruby(ruby_version)
    ChefSpec::Matchers::ResourceMatcher.new(:rbenv_ruby, :install, ruby_version)
  end

  def install_rbenv_gem(package_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rbenv_gem, :install, package_name)
  end

  def create_cookbook_ci(cookbook)
    ChefSpec::Matchers::ResourceMatcher.new(:jenkins_ci_cookbook_ci, :create, cookbook)
  end

  def enable_cookbook_ci(cookbook)
    ChefSpec::Matchers::ResourceMatcher.new(:jenkins_ci_cookbook_ci, :enable, cookbook)
  end

  def disable_cookbook_ci(cookbook)
    ChefSpec::Matchers::ResourceMatcher.new(:jenkins_ci_cookbook_ci, :disable, cookbook)
  end

  def delete_cookbook_ci(cookbook)
    ChefSpec::Matchers::ResourceMatcher.new(:jenkins_ci_cookbook_ci, :delete, cookbook)
  end
end
