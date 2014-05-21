Gem::Specification.new do |s|
	s.name			= 'rork'
	s.version		= '0.1.0'
	s.summary		= 'ruby fork'
	s.description	= 'Run applications as daemon with ruby.'
	s.license		= 'MIT'
	s.platform		= Gem::Platform::RUBY

	s.has_rdoc		= true
	s.extra_rdoc_files = ['README.md', 'LICENSE']
	s.rdoc_options 	<< "--main" << "README.md"
	s.rdoc_options 	<< "--encoding" << "UTF-8"

	s.bindir		= 'bin'
	s.executables 	<< 'rork'
	s.files			= s.extra_rdoc_files + 
		Dir['bin/*'] + Dir['lib/*.rb'] + Dir['lib/*/*.rb']

	s.author		= 'gyf1214'
	s.email			= 'gyf1214@gmail.com'
	s.homepage		= 'https://github.com/gyf1214/rork'
end