Gem::Specification.new do |s|
  s.name = 'lc-api'
  s.version = '1.0.0'
  s.date = '2013-05-03'
  s.summary = 'LC API'
  s.description = 'A Ruby wrapper for the Lifechurch.tv REST API'
  s.authors = ["Daniel Long", "Scott Lesser"]
  s.email = 'webmaster@lifechurch.tv'
  s.files = [
    'lib/lc-api.rb', 
    'lib/lc-api/api.rb', 
    'lib/lc-api/error_codes.rb',
    'lib/lc-api/resource.rb',
    'lib/lc-api/resource/category.rb',
    'lib/lc-api/resource/location.rb',
    'lib/lc-api/resource/message.rb',
    'lib/lc-api/resource/series.rb',
    'lib/lc-api/resource/speaker.rb',
    'lib/lc-api/resource/staff.rb'
    ]
  s.homepage = 'http://rubygems.org/gems/lc-api'
  s.add_dependency('httparty', '>= 0')
  s.add_dependency('activesupport', '>= 2.2.1')
  s.add_development_dependency('rspec', '~> 2.13.0')
end