require 'rexml/document'
include REXML

module NalMods
	class ModsResourceType
		attr_accessor(:value)

		def initialize
			@value = nil
		end

		def get_rtype(xml)
			@value = xml.elements["mods/typeOfResource"].text unless xml.elements["mods/typeOfResource"].nil?
		end 
	end
end

if __FILE__ == $0
	xmldoc = (Document.new File.new "test.xml")
 	
 	type = ModsResourceType.new
 	# type.value = xmldoc.elements["mods/typeOfResource"].text unless xmldoc.elements["mods/typeOfResource"].nil?
 	type.get_rtype(xmldoc)
		
	puts type.value
end