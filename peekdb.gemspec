Gem::Specification.new do |gem|
  gem.name        = "peekdb"
  gem.version     = "0.2.1"
  gem.platform    = Gem::Platform::RUBY
  gem.authors     = ["Adrian Smith"]
  gem.email       = ["adrian.smith@ennova.com.au"]
  gem.homepage    = "https://github.com/AdrianSmith/peekdb"
  gem.summary     = %q{PeekDB generates a quick view of the tables and relationships in a database}
  gem.description = %q{PeekDB is a command line utility that builds a simple force-directed ER diagram for a database. The output can be .png or .dot formats.}
  gem.license     = 'MIT'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")

  gem.add_dependency 'ruby-graphviz'
  gem.add_dependency 'pg'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
end
