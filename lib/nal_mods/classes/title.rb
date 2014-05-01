require 'nokogiri'
require_relative '../modules/printable'
require_relative '../modules/retrievable'
include REXML

module NalMods
	class ModsTitle
		include Printable
		include Retrievable

		attr_accessor(:type,:title,:subtitle)

		def initialize
			@type = nil
			@title = nil
			@subtitle = nil
		end

		def get_title(e)
			@title = get_etext(e,'title')
			@subtitle = get_etext(e,'subTitle')
		end

		def set_text(e)
			e.elements["title"].text = @title unless e.elements["title"].nil?
			e.elements["subTitle"].text = @subtitle unless e.elements["subTitle"].nil?
		end

	end
end

if __FILE__ == $0
	xmldoc = (Document.new File.new "test.xml")
	
 	xmldoc.elements.each("mods/titleInfo") do |e|
		# title = ModsTitle.new
		# title.type = title.get_atext(e,"type")
		# title.title = title.get_etext(e,'title')
		# title.subtitle = title.get_etext(e,'subTitle')
		title = ModsTitle.new
		title.get_title(e) 	
	 	
		title.print_vals
	end
	
end