require_relative '../modules/retrievable'
require_relative '../modules/printable'
require 'rexml/document'
include REXML

module NalMods
	class ModsToc
		attr_accessor(:value)
		include Printable
		include Retrievable

		def initialize
			@value = nil
		end

		def get_toc(e)
			@value = e.text unless e.text.nil?
		end

		def set_text(e)
			e.text = @value unless e.text.nil?
		end
	end


	if __FILE__ == $0
		xmldoc = (Document.new File.new "test.xml")

		values = [nil]
	 	
	 	xmldoc.elements.each("mods/tableOfContents") do |e|
	 		toc = ModsToc.new unless e.nil?
	 		toc.value = e.text unless e.text.nil?
	 		values << toc.value unless e.text.nil?
	 		values.compact! unless e.text.nil?
	 	end

		values.each do |v|
			puts v unless v.nil?
			puts "nil" if v.nil?
		end
	end
end