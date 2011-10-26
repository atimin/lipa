lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'lipa/version'

Gem::Specification.new do |gem|
  gem.name = "lipa"
  gem.version = Lipa::VERSION
  gem.author  = 'A.Timin'
  gem.email = "atimin@gmail.com"
  gem.homepage = "http://lipa.flipback.net"
  gem.summary = "Lipa - DSL for description treelike structures in Ruby"
  gem.files = Dir['lib/**/*.rb','spec/*.rb', 'examples/**/*.rb','Rakefile']
  gem.rdoc_options = ["--title", "Lipa", "--inline-source", "--main", "README.md"]
  gem.extra_rdoc_files = ["README.md", "NEWS.md"]

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'yard'
  gem.add_development_dependency 'rdiscount'
  gem.add_development_dependency 'pry'
end
