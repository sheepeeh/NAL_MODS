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
