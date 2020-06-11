require './lib/manage_meta/version'
# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "manage_meta"
  s.author = "Mike Howard"
  s.email = "mike@clove.com"
  s.homepage = "http://github.com/mikehoward/manage_meta"
  s.summary = "ManageMeta - Yet Another Meta Tag manager for Rails 3"
  s.description = "Provides (semi-)intellegent management of meta tags for Rails 3"
  s.files = Dir["{lib,test}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.markdown"]
  s.version = ManageMeta::VERSION
end
