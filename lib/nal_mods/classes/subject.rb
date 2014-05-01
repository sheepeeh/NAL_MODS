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

if __FILE__ == $0
	xmldoc = (Document.new File.new "test.xml")

	topics = []
	genres = []
	locs = []
	times = []
	names = []
	titles = []

	xmldoc.elements.each("mods/subject") do |e|
		topic = ModsSubject.new
		topic.auth = topic.get_atext(e,'authority')
		topic.authURI = topic.get_atext(e,'authorityURI')
		topic.valueURI = topic.get_atext(e,'valueURI')
		topic.topic = topic.get_etext(e,'topic')
		topics << topic
		topic.print_vals

		genre = ModsSubject.new
		genre.authURI = genre.get_atext(e,'authorityURI')
		genre.valueURI = genre.get_atext(e,'valueURI')
		genre.genre = genre.get_etext(e,'genre')
		genres << genre
		genre.print_vals

		geo = ModsSubject.new
		geo.auth = geo.get_atext(e,'authority')
		geo.authURI = geo.get_atext(e,'authorityURI')
		geo.valueURI = geo.get_atext(e,'valueURI')
		geo.geo = geo.get_etext(e,'geographic')
		locs << geo
		geo.print_vals

		time = ModsSubject.new
		time.auth = time.get_atext(e,'authority')
		time.authURI = time.get_atext(e,'authorityURI')
		time.valueURI = time.get_atext(e,'valueURI')
		time.time = time.get_etext(e,'time')
		times << time
		time.print_vals

		if e.elements['hierarchicalGeographic'] != nil
			e.elements.each('hierarchicalGeographic') do |h|
				hgeo = ModsSubject::HGeo.new
				hgeo.continent = hgeo.get_etext(h,'continent')
				hgeo.country = hgeo.get_etext(h,'country')
				hgeo.province = hgeo.get_etext(h,'province')
				hgeo.region = hgeo.get_etext(h,'region')
				hgeo.state = hgeo.get_etext(h,'state')
				hgeo.territory = hgeo.get_etext(h,'territory')
				hgeo.county = hgeo.get_etext(h,'county')
				hgeo.city = hgeo.get_etext(h,'city')
				hgeo.citySection = hgeo.get_etext(h,'citySection')
				hgeo.island = hgeo.get_etext(h,'island')
				hgeo.area = hgeo.get_etext(h,'area')
				hgeo.et_area = hgeo.get_etext(h,'extraterrestrialArea')

				puts "\nHGEO:"
				hgeo.print_vals
			end
		end

		if e.elements['name'] != nil
			names = []
			e.elements.each('name') do |n|
				name = ModsName.new
				name.type = name.get_atext(n,'type')
				name.authority = name.get_atext(n,'authority')
				name.authURI = name.get_atext(n,'authorityURI')
				name.valueURI = name.get_atext(n,'valueURI')
				  
				name.full = name.get_etext(n,"namePart[not(@*)]")
				name.given = name.get_etext(n,"namePart[@type='given']")
				name.family = name.get_etext(n,"namePart[@type='family']")
				name.affil = name.get_etext(n,"affiliation")
				  
				name.role_text = name.get_etext(n,"role/roleTerm[@type='text']")
				name.role_code = name.get_etext(n,"role/roleTerm[@type='code']")
				
				name.instance_variables.each do |v|
					val = name.instance_variable_get(v)
					name.remove_instance_variable(v) if val == nil || val == ""
				end
				puts "\nNAMES:"
				name.print_vals
				names << name
			end
		end

		if e.elements['titleInfo'] != nil
			e.elements.each('titleInfo') do |t|
				title = ModsTitle.new
				title.type = title.get_atext(t,'type')
				title.title = title.get_etext(t,'title')
				title.subtitle = title.get_etext(t,'subTitle')

				title.instance_variables.each do |v|
					val = title.instance_variable_get(v)
					title.remove_instance_variable(v) if val == nil || val == ""
				end
				puts "\nTITLES:"
				title.print_vals
				titles << title
			end
		end
	end
end