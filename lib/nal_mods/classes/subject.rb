require 'rexml/document'
include REXML
require_relative "name"
require_relative "title"
require_relative '../modules/retrievable'
require_relative '../modules/printable'

module NalMods
	class ModsSubject
		attr_accessor(:authURI,:valueURI,:auth,:topic,:geo,:time,:genre)
		include Printable
		include Retrievable

		def initialize
			@auth = nil
			@authURI = nil
			@valueURI = nil
			@topic = nil
			@geo = nil
			@time = nil
			@genre = nil
		end

		def get_topic(e)
			@topic = e.text unless e.nil?
		end 

		def get_genre(e)
			@genre = get_etext(e,'genre')
		end 

		def get_geo(e)
			@geo = get_etext(e,'geographic')
		end 

		def get_time(e)
			@time = get_etext(e,'temporal')
		end 

		def set_topic(e)
			e.text = @topic unless e.nil?
		end 

		def set_genre(e)
			e.text = @genre unless e.nil?
		end 

		def set_geo(e)
			e.text = @geo unless e.nil?
		end 

		def set_time(e)
			e.text = @time unless e.nil?
		end

		
		class HGeo
			attr_accessor(:continent, :country, :province, :region, :state, :territory, :county, :city, :citySection, :island, :area, :et_area, :address_string)
			include Printable
			include Retrievable

			def initialize
				@continent = nil
				@country = nil
				@province = nil
				@region = nil
				@state = nil
				@territory = nil
				@county = nil
				@city = nil
				@citySection = nil
				@island = nil
				@area = nil
				@et_area = nil
				@address_string = nil
			end

			def get_hgeo(e)
				@continent = get_etext(h,'continent')
				@country = get_etext(h,'country')
				@province = get_etext(h,'province')
				@region = get_etext(h,'region')
				@state = get_etext(h,'state')
				@territory = get_etext(h,'territory')
				@county = get_etext(h,'county')
				@city = get_etext(h,'city')
				@citySection = get_etext(h,'citySection')
				@island = get_etext(h,'island')
				@area = get_etext(h,'area')
				@et_area = get_etext(h,'extraterrestrialArea')
			end

			def set_text(e)
				e.elements['continent'].text = @continent unless e.elements['continent'].nil?
				e.elements['country'].text = @country unless e.elements['country'].nil?
				e.elements['province'].text = @province unless e.elements['province'].nil?
				e.elements['region'].text = @region unless e.elements['region'].nil?
				e.elements['state'].text = @state unless e.elements['state'].nil?
				e.elements['territory'].text = @territory unless e.elements['territory'].nil?
				e.elements['county'].text = @county unless e.elements['county'].nil?
				e.elements['city'].text = @city unless e.elements['city'].nil?
				e.elements['citySection'].text = @citySection unless e.elements['citySection'].nil?
				e.elements['island'].text = @island unless e.elements['island'].nil?
				e.elements['area'].text = @area unless e.elements['area'].nil?
				e.elements['et_area'].text = @et_area unless e.elements['et_area'].nil?
				e.elements['address_string'].text = @address_string unless e.elements['address_string'].nil?
			end
		end
	end
end
