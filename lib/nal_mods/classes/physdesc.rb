require 'rexml/document'
include REXML
require_relative '../modules/retrievable'
require_relative '../modules/printable'


module NalMods
	class ModsPhysDesc
		attr_accessor(:form,:extent,:qual,:note,:note_type,:origin)
		include Printable
		include Retrievable

		def initialize
			@form = nil
			@extent = nil
			@note = nil
			@note_type = nil
			@qual = nil
			@origin = nil
		end

		def get_pdesc(e)
			@form = get_etext(e,"form")
			@extent = get_etext(e,"extent")
		end

		def set_text(e)
			e.elements["form"].text = @form unless e.elements["form"].nil?
			e.elements["extent"].text = @extent unless e.elements["extent"].nil?
		end
	end
end


if __FILE__ == $0
	xmldoc = (Document.new File.new "test.xml")
 	
 	xmldoc.elements.each("mods/physicalDescription") do |e|
		pdesc = ModsPhysDesc.new
		pdesc.form = pdesc.get_etext(e, 'form')
		pdesc.extent = pdesc.get_etext(e, 'extent')
		pdesc.note = pdesc.get_etext(e, 'note')
		pdesc.note_type = pdesc.get_atext(e.elements['note'],'type')
		pdesc.qual = pdesc.get_etext(e, 'reformattingQuality')
		pdesc.origin = pdesc.get_etext(e, 'digitalOrigin')

		pdesc.print_vals
	end
end