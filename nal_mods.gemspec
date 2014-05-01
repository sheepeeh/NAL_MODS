$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s| 
  s.name         = "nal_mods"
  s.version      = 0.1.0.pre
  s.author       = "Rachel Donahue, National Agricultural Library"
  s.summary      = "A MODS library for converting XML to/from CSV. Originally intended to make it easier to use Open Refine for metadata normalization."
  s.homepage     = "http://nal.ars.usda.gov"
  s.description  = File.read(File.join(File.dirname(__FILE__), 'README.md'))
  
  s.files         = `git ls-files`.split("n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  
  s.required_ruby_version = '>=2.0'
end