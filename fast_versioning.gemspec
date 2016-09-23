$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "fast_versioning"
  s.version     = '0.1.1'
  s.authors     = ['Arcadia Power', 'Iwo Dziechciarow']
  s.email       = ['engineering@arcadiapower.com']
  s.homepage    = 'https://github.com/ArcadiaPower/fast-versioning'
  s.summary     = 'Fast versioning extension for paper_trail'
  s.description = 'Fast versioning extension for paper_trail'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'Rakefile', 'README.md']

  s.add_dependency 'rails'
  s.add_dependency 'paper_trail', '~>4.2'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
end
