require File.expand_path('lib/foreman_custom_column/version', __dir__)

Gem::Specification.new do |s|
  s.name        = 'foreman_custom_column'
  s.version     = ForemanCustomColumn::VERSION
  s.metadata    = { 'is_foreman_plugin' => 'true' }
  s.license     = 'GPL-3.0'
  s.authors     = ['gsdc']
  s.email       = ['']
  s.homepage    = 'https://github.com/gsdc/foreman_custom_column'
  s.summary     = 'Summary of ForemanCustomColumn.'
  # also update locale/gemspec.rb
  s.description = 'Description of ForemanCustomColumn.'

  s.files = Dir['{app,config,db,lib,locale,webpack}/**/*'] + ['LICENSE', 'Rakefile', 'README.md', 'package.json']
  s.test_files = Dir['test/**/*'] + Dir['webpack/**/__tests__/*.js']

  s.required_ruby_version = '>= 2.7', '< 4'

  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-minitest'
  s.add_development_dependency 'rubocop-performance'
  s.add_development_dependency 'rubocop-rails'
end
