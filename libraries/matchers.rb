if defined?(ChefSpec)
  def create_cookbook_ci(cookbook)
    ChefSpec::Matchers::ResourceMatcher.new(:cookbook_ci, :create, cookbook)
  end

  def enable_cookbook_ci(cookbook)
    ChefSpec::Matchers::ResourceMatcher.new(:cookbook_ci, :enable, cookbook)
  end

  def disable_cookbook_ci(cookbook)
    ChefSpec::Matchers::ResourceMatcher.new(:cookbook_ci, :disable, cookbook)
  end

  def delete_cookbook_ci(cookbook)
    ChefSpec::Matchers::ResourceMatcher.new(:cookbook_ci, :delete, cookbook)
  end
end
