require 'rexml/document'
include REXML

require_relative 'name'
require_relative 'title'
require_relative 'identifier'
require_relative 'resourcetype'
require_relative 'genre'
require_relative 'origin'
require_relative 'language'
require_relative 'physdesc'

require_relative '../modules/retrievable'
require_relative '../modules/printable'

module NalMods
	class ModsRelated
		attr_accessor(:type,:names,:titles,:identifiers,:resourcetype,:genres,:origin,:languages,:physdesc)
		include Printable
		include Retrievable

		def initialize
			@type = nil
			@names = [nil] 
			@titles = [nil] 
			@identifiers = [nil] 
			@resourcetype = nil 
			@genres = [nil] 
			@origin = nil 
			@languages = [nil] 
			@physdesc = nil 
		end


		def add_name(value)
			@names << value
		end

		def add_title(value)
			@titles << value
		end

		def add_id(value)
			@identifiers << value
		end

		def add_genre(value)
			@genres << value
		end

		def add_lang(value)
			@languages << value
		end
	end
end
