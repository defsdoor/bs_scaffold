$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "bsscaffold-generator"
  s.version     = "0.1"
  s.platform    = "ruby"
  s.authors     = ["Andrew Porter"]
  s.email       = ["andy@defsdoor.org"]
  s.homepage    = "https://github.com/defsdoor/bsscaffold-generator"
  s.summary     = %q{A rails scaffold generator for my bootstrap pages.}
  s.description = %q{This generator will allow you to create scaffold for my bootstrap pages - rails g bs_scaffold:controller model}
  s.files = Dir.glob("{lib}/**/*")
  s.require_path = 'lib'
  s.add_development_dependency 'rails', '~> 5.0.0'
end
