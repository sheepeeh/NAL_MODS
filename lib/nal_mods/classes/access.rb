require 'rexml/document'
include REXML
require_relative '../modules/retrievable'
require_relative '../modules/printable'
require_relative '../modules/walkable'

module NalMods
	class ModsAccess
		attr_accessor(:use,:restrict)
		include Printable
		include Retrievable
		include Walkable

		def initialize
			@use = nil
			@restrict = nil
		end

		def get_vals(par)
			@use = get_etext(par,"accessCondition[@type='useAndReproduction']")
			@restrict = get_etext(par,"accessCondition[@type='restrictionOnAccess']")
		end
	end
end

if __FILE__ == $0
	xmldoc = (Document.new File.new "test.xml")

	access = ModsAccess.new

	xmldoc.elements.each("mods") do |e|
		access.get_vals(e)
		access.print_vals
	end
end