require 'rexml/document'
include REXML
require_relative '../modules/retrievable'
require_relative '../modules/printable'

module NalMods
	class ModsGenre
		attr_accessor(:auth,:authURI,:value,:valueURI)
		include Printable
		include Retrievable

		def initialize
			@auth = nil
			@authURI = nil
			@valueURI = nil
			@value = nil
		end
	end
end


if __FILE__ == $0
	xmldoc = (Document.new File.new "test.xml")
 	
 	xmldoc.elements.each("mods/genre") do |e|
		genre = ModsGenre.new
		genre.auth = genre.get_atext(e, 'authority')
		genre.authURI = genre.get_atext(e, 'authorityURI')
		genre.valueURI = genre.get_atext(e, 'valueURI')
		genre.value = e.text unless e.nil?

		genre.print_vals
	end
end