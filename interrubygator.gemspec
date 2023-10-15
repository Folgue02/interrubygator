require 'rake'
require_relative 'lib/version'

Gem::Specification.new do |s|
  s.name = 'interrubygator'
  s.author = 'Folgue02'
  s.summary = 'A simple script to read and prompt questions to the user.'
  s.version = VERSION 
  s.files = FileList['lib/**/*.rb', 'bin/*']
  s.executables << 'interrubygator'
end
