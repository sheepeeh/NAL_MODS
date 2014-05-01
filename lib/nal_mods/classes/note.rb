require 'rexml/document'
include REXML
require_relative '../modules/retrievable'
require_relative '../modules/printable'

module NalMods
	class ModsNote
		attr_accessor(:value,:type)
		include Printable
		include Retrievable
		def initialize
			@value = nil
			@type = nil
		end
	end
end


if __FILE__ == $0
	xmldoc = (Document.new File.new "test.xml")
	
 	xmldoc.elements.each("mods/note") do |e|
 		note = nil if e.nil?
 		note = ModsNote.new unless e.nil?
 		note.value = e.text unless e.text.nil?
 		note.type = e.attributes['type'] unless e.attributes['type'].nil?
 		note.print_vals
 	end
end