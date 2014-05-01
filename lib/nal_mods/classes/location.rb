require 'rexml/document'
include REXML
require_relative '../modules/retrievable'
require_relative '../modules/printable'

module NalMods
	class ModsLocation
		attr_accessor(:location,:shelf,:url)
		include Printable
		include Retrievable

		def initialize
			@location = nil
			@shelf = nil
			@url = nil
		end

		def get_loc(e)
			@location = get_etext(e,"physicalLocation")
			@shelf = get_etext(e,"//copyInformation/shelfLocator")
			@url = get_etext(e,"url")
		end

		def set_text(e)
			e.elements['physicalLocation'].text = @location unless e.elements['physicalLocation'].nil?
			e.elements['copyInformation/shelfLocator'].text = @shelf unless e.elements['copyInformation/shelfLocator'].nil?
			e.elements['holdingSimple/copyInformation/shelfLocator'].text = @shelf unless e.elements['holdingSimple/copyInformation/shelfLocator'].nil?
			e.elements['url'].text = @url unless e.elements['url'].nil?
		end
	end
end


