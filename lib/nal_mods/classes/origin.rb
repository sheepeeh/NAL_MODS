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