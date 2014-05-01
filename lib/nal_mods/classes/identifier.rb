require 'rexml/document'
include REXML
require_relative '../modules/retrievable'
require_relative '../modules/printable'

module NalMods
	class ModsIdentifier
		attr_accessor(:type,:value)	
		include Printable
		include Retrievable

		def initialize
			@type = nil
			@value = nil
		end
	end
end

if __FILE__ == $0
	xmldoc = (Document.new File.new "test.xml")
 	
 	xmldoc.elements.each("mods/identifier") do |e|
		id = ModsIdentifier.new
		id.type = e.attributes['type'] unless e.attributes['type'].nil?
		id.value = e.text unless e.nil?

		id.print_vals
	end
end