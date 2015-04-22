Gem::Specification.new do |s|
  s.name              = 'sapluuna'
  s.version           = '0.1.0'
  s.licenses          = %w( Apache-2.0 )
  s.platform          = Gem::Platform::RUBY
  s.authors           = [ 'Saku Ytti' ]
  s.email             = %w( saku@ytti.fi )
  s.homepage          = 'http://github.com/ytti/sapluuna'
  s.summary           = 'Template parser'
  s.description       = 'Template based network configuration generator'
  s.rubyforge_project = s.name
  s.files             = `git ls-files`.split("\n")
  s.executables       = %w( sapluuna )
  s.require_path      = 'lib/sapluuna'

  s.required_ruby_version =        '>= 2.0.0'
  s.add_runtime_dependency 'slop', '~> 4.0'
end
