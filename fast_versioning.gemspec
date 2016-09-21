$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "fast_versioning"
  s.version     = '0.1.0'
  s.authors     = ['Arcadia Power']
  s.email       = ['info@arcadiapower.com']
  s.homepage    = 'http://www.arcadiapower.com'
  s.summary     = 'Fast versioning extension for paper_trail'
  s.description = 'Fast versioning extension for paper_trail'

  s.files = Dir['{app,config,db,lib}/**/*', 'Rakefile', 'README.md']

  s.add_dependency 'rails'
  s.add_dependency 'paper_trail', '~>4.2'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
end
