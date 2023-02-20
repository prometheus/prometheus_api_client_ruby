source 'https://rubygems.org'

gemspec

def ruby_version?(constraint)
  Gem::Dependency.new('', constraint).match?('', RUBY_VERSION)
end

gem 'faraday'

group :test do
  gem 'coveralls'
  gem 'rake'
  gem 'rspec'
  gem 'rubocop'
  gem 'vcr'
  gem 'webmock'
end
