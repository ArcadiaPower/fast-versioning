$:.push File.expand_path('../lib', __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'fast_versioning'
  s.version     = '0.4.0'
  s.authors     = ['Arcadia Power', 'Iwo Dziechciarow', 'Justin Doody']
  s.email       = ['engineering@arcadiapower.com']
  s.homepage    = 'https://github.com/ArcadiaPower/fast-versioning'
  s.summary     = 'Fast versioning extension for paper_trail'
  s.description = 'Fast versioning extension for paper_trail'
  s.license     = 'MIT'

  s.files = Dir['{app,db,lib}/**/*', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 5.0'
  s.add_dependency 'paper_trail', '>= 4.2'

  s.add_development_dependency 'sqlite3', '~> 1.3.13'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'appraisal'
end
