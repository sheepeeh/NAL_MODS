require 'rexml/document'
require_relative '../modules/printable'
require_relative '../modules/retrievable'
include REXML

module NalMods
	class ModsOrigin
		attr_accessor(:place, :place_type, :publisher, :copyright, :created, :issued, :issuance, :role_text, :role_code, :affil, :origins)
		include Printable
		include Retrievable

		def initialize
			@place = nil
			@place_type = nil
			@publisher = nil
			@issuance = nil
			@copyright = nil
			@created = nil
			@issued = nil
		end

		def get_place(e)
			@place = get_etext(e, "place/placeTerm")
		end

		def get_publisher(e)
			@publisher = get_etext(e, 'publisher')
		end

		def get_issuance(e)
			@issuance = get_etext(e,'issuance')

		end

		def set_text(e)
			e.elements["publisher"].text = @publisher unless e.elements["publisher"].nil?
			e.elements["place/placeTerm"].text = @place unless e.elements["place"].nil?
			e.elements["issuance"].text = @issuance unless e.elements["issuance"].nil?
		end
		
		class Copyright 
			attr_accessor(:encoding,:qualifier,:value,:start,:start_qualifier,:end,:end_qualifier)
			include Printable
			include Retrievable

			def initialize
				@encoding = nil
				@qualifier = nil
				@value = nil
				@start = nil
				@start_qualifier = nil
				@end = nil
				@end_qualifier = nil
			end

			def get_date(e)
				@value = get_etext(e,'copyrightDate[not(@point)]')
			end

			def get_end(e)
				@end = get_etext(e, "copyrightDate[@point='end']")
			end

			def get_start(e)
				@start = get_etext(e, "copyrightDate[@point='start']")
			end

			def set_text(e)	
				e.elements['copyrightDate[not(@point)]'].text = @value unless e.elements['copyrightDate[not(@point)]'].nil?
				e.elements["copyrightDate[@point='end']"].text = @start unless e.elements["copyrightDate[@point='end']"].nil?
				e.elements["copyrightDate[@point='start']"].text = @end unless e.elements["copyrightDate[@point='start']"].nil?
			end
		end

		class Created
			attr_accessor(:encoding,:qualifier,:value,:start,:start_qualifier,:end,:end_qualifier)
			include Printable
			include Retrievable

			def initialize
				@encoding = nil
				@qualifier = nil
				@value = nil
				@start = nil
				@start_qualifier = nil
				@end = nil
				@end_qualifier = nil
			end

			def get_date(e)
				@value = get_etext(e,'dateCreated[not(@point)]')
			end

			def get_end(e)
				@end = get_etext(e, "dateCreated[@point='end']")
			end

			def get_start(e)
				@start = get_etext(e, "dateCreated[@point='start']")
			end

			def set_text(e)	
				e.elements['dateCreated[not(@point)]'].text = @value unless e.elements['dateCreated[not(@point)]'].nil?
				e.elements["dateCreated[@point='end']"].text = @start unless e.elements["dateCreated[@point='end']"].nil?
				e.elements["dateCreated[@point='start']"].text = @end unless e.elements["dateCreated[@point='start']"].nil?
			end
		end


		class Issued
			attr_accessor(:encoding,:qualifier,:value,:start,:start_qualifier,:end,:end_qualifier)
			include Retrievable
			include Printable

			def initialize
				@encoding = nil
				@qualifier = nil
				@value = nil
				@start = nil
				@start_qualifier = nil
				@end = nil
				@end_qualifier = nil
			end
			
			def get_date(e)
				@value = get_etext(e,'dateIssued[not(@point)]')
			end

			def get_end(e)
				@end = get_etext(e, "dateIssued[@point='end']")
			end

			def get_start(e)
				@start = get_etext(e, "dateIssued[@point='start']")
			end


			def set_text(e)	
				e.elements['dateIssued[not(@point)]'].text = @value unless e.elements['dateIssued[not(@point)]'].nil?
				e.elements["dateIssued[@point='end']"].text = @start unless e.elements["dateIssued[@point='end']"].nil?
				e.elements["dateIssued[@point='start']"].text = @end unless e.elements["dateIssued[@point='start']"].nil?
			end

		end

		def print_origin
			puts "\nORIGIN"
			self.print_vals
			puts "\nCREATED"
			@created.print_vals unless @created.nil?
			puts "\nCOPYRIGHT"
			@copyright.print_vals unless @copyright.nil?
			puts "\nISSUED"
			@issued.print_vals unless @issued.nil?
		end


		def add_origin(origin)
			@origins << origin
		end
	end
end


if __FILE__ == $0
	xmldoc = (Document.new File.new "test.xml")

	xmldoc.elements.each("mods/originInfo") do |e|
		origin = ModsOrigin.new
		origin.place_type = origin.get_atext(e.elements["place/placeTerm"],'type')
		origin.place = origin.get_etext(e, "place/placeTerm")
		origin.publisher = origin.get_etext(e, "publisher")

	# copyrightDate
		copyright = ModsOrigin::Copyright.new	
		copyright.encoding = copyright.get_atext(e.elements['copyrightDate[not(@point)]'],'encoding')
		copyright.qualifier = copyright.get_atext(e.elements['copyrightDate[not(@point)]'], 'qualifier')
		copyright.value = copyright.get_etext(e,'copyrightDate[not(@point)]')
		
		copyright.start_qualifier = copyright.get_atext(e.elements["copyrightDate[@point='start']"], 'qualifier')
		copyright.start = copyright.get_etext(e, "copyrightDate[@point='start']")

		copyright.end_qualifier = copyright.get_atext(e.elements["copyrightDate[@point='end']"], 'qualifier')
		copyright.end = copyright.get_etext(e, "copyrightDate[@point='end']")

		origin.copyright = copyright
		
	#dateCreated
		created = ModsOrigin::Created.new
		created.encoding = created.get_atext(e.elements['dateCreated[not(@point)]'],'encoding')
		created.qualifier = created.get_atext(e.elements['dateCreated[not(@point)]'], 'qualifier')
		created.value = created.get_etext(e,'dateCreated[not(@point)]')
		
		created.start_qualifier = created.get_atext(e.elements["dateCreated[@point='start']"], 'qualifier')
		created.start = created.get_etext(e, "dateCreated[@point='start']")

		created.end_qualifier = created.get_atext(e.elements["dateCreated[@point='end']"], 'qualifier')
		created.end = created.get_etext(e, "dateCreated[@point='end']")

		origin.created = created
		
	# dateIssued
		issued = ModsOrigin::Issued.new
		issued.encoding = issued.get_atext(e.elements['dateIssued[not(@point)]'],'encoding')
		issued.qualifier = issued.get_atext(e.elements['dateIssued[not(@point)]'], 'qualifier')
		issued.value = issued.get_etext(e,'dateIssued[not(@point)]')
		
		issued.start_qualifier = issued.get_atext(e.elements["dateIssued[@point='start']"], 'qualifier')
		issued.start = issued.get_etext(e, "dateIssued[@point='start']")

		issued.end_qualifier = issued.get_atext(e.elements["dateIssued[@point='end']"], 'qualifier')
		issued.end = issued.get_etext(e, "dateIssued[@point='end']")

		origin.issued = issued

		origin.issuance = issued.end = issued.get_etext(e, "issuance")
		
		origin.print_origin
	end	
end