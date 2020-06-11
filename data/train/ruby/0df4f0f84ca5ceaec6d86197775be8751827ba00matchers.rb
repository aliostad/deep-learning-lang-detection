if defined?(ChefSpec)
  ChefSpec.define_matcher :keytool_manage

  def exportcert_keytool_manage(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:keytool_manage, :exportcert, resource_name)
  end

  def importcert_keytool_manage(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:keytool_manage, :importcert, resource_name)
  end

  def importkeystore_keytool_manage(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:keytool_manage, :importkeystore, resource_name)
  end

  def deletecert_keytool_manage(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:keytool_manage, :deletecert, resource_name)
  end

  def storepasswd_keytool_manage(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:keytool_manage, :storepasswd, resource_name)
  end
end
