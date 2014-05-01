require 'rexml/document'
include REXML
require_relative '../modules/printable'
require_relative '../modules/retrievable'

module NalMods
	class ModsAbstract
		attr_accessor(:value)
		include Printable
		include Retrievable

		def initialize
			@value = nil
		end

		def get_value(par)
			@value = get_etext(par,"abstract")
		end
	end
end


if __FILE__ == $0
	xmldoc = (Document.new File.new "test.xml")
 	xmldoc.elements.each("mods") do |e|
	 	abs = ModsAbstract.new
	 	abs.get_value(e)
		puts abs.value
	end
end