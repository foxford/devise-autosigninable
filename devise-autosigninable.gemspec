require File.expand_path('../lib/devise/autosigninable/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Andrey Deryabin']
  gem.description   = 'It adds support to be logged in by uniq link'
  gem.summary       = 'It adds support to be logged in by uniq link. It useful for mailing and access from admin panel'
  gem.homepage      = 'http://github.com/plataformatec/devise-autosigninable'
  gem.license       = 'MIT'

  gem.files         = Dir['LICENSE', 'README.md', 'lib/**/*']
  gem.test_files    = Dir['test/**/*.rb']
  gem.name          = 'devise-autosigninable'
  gem.require_paths = ['lib']
  gem.version       = Devise::Autosigninable::VERSION

  gem.add_dependency 'devise', '>= 4.0.0'
end
