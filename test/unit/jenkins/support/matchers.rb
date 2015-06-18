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
end
