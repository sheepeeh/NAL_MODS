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

if __FILE__ == $0
	xmldoc = (Document.new File.new "test.xml")

	xmldoc.elements.each("mods/relatedItem") do |e|
		item = ModsRelated.new
		item.type = item.get_atext(e,'type')
		
		item.resourcetype = ModsResourceType.new
 		item.resourcetype = xmldoc.elements["typeOfResource"].text unless xmldoc.elements["typeOfResource"].nil?
		puts item.resourcetype.value
		

# ID
		e.elements.each("identifier") do |e|
			id = ModsIdentifier.new
			id.type = e.attributes['type'] unless e.attributes['type'].nil?
			id.value = e.text unless e.nil?

			puts "\nIDENTIFIER"
			id.print_vals
			item.add_id(id)
		end

# GENRE
	e.elements.each("genre") do |e|
		genre = ModsGenre.new
		genre.auth = genre.get_atext(e, 'authority')
		genre.authURI = genre.get_atext(e, 'authorityURI')
		genre.valueURI = genre.get_atext(e, 'valueURI')
		genre.value = e.text unless e.nil?

		genre.print_vals
		item.add_genre(genre)
	end
# NAME
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
			item.add_name(name)
		end
# TITLE
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
				item.add_title(title)
			end
		end
# ORIGIN INFO
		e.elements.each("originInfo") do |e|
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

			copyright.instance_variables.each do |v|
				val = copyright.instance_variable_get(v)
				copyright.remove_instance_variable(v) if val == nil || val == ""
			end

			origin.copyright = copyright unless copyright.nil?
			
		#dateCreated
			created = ModsOrigin::Created.new
			created.encoding = created.get_atext(e.elements['dateCreated[not(@point)]'],'encoding')
			created.qualifier = created.get_atext(e.elements['dateCreated[not(@point)]'], 'qualifier')
			created.value = created.get_etext(e,'dateCreated[not(@point)]')
			
			created.start_qualifier = created.get_atext(e.elements["dateCreated[@point='start']"], 'qualifier')
			created.start = created.get_etext(e, "dateCreated[@point='start']")

			created.end_qualifier = created.get_atext(e.elements["dateCreated[@point='end']"], 'qualifier')
			created.end = created.get_etext(e, "dateCreated[@point='end']")

			created.instance_variables.each do |v|
				val = created.instance_variable_get(v)
				created.remove_instance_variable(v) if val == nil || val == ""
			end


			origin.created = created unless created.nil?

		# dateIssued
			issued = ModsOrigin::Issued.new
			issued.encoding = issued.get_atext(e.elements['dateIssued[not(@point)]'],'encoding')
			issued.qualifier = issued.get_atext(e.elements['dateIssued[not(@point)]'], 'qualifier')
			issued.value = issued.get_etext(e,'dateIssued[not(@point)]')
			
			issued.start_qualifier = issued.get_atext(e.elements["dateIssued[@point='start']"], 'qualifier')
			issued.start = issued.get_etext(e, "dateIssued[@point='start']")

			issued.end_qualifier = issued.get_atext(e.elements["dateIssued[@point='end']"], 'qualifier')
			issued.end = issued.get_etext(e, "dateIssued[@point='end']")

			issued.instance_variables.each do |v|
				val = issued.instance_variable_get(v)
				issued.remove_instance_variable(v) if val == nil || val == ""
			end

			origin.issued = issued unless issued.nil?

			origin.issuance = issued.end = issued.get_etext(e, "issuance")

			origin.instance_variables.each do |v|
				val = origin.instance_variable_get(v)
				origin.remove_instance_variable(v) if val == nil || val == ""
			end
			item.origin = origin
			
			item.origin.print_origin

		end


# LANGUAGE
	 	e.elements.each("language") do |e|
			lang = ModsLang.new
			lang.auth = lang.get_atext(e,'authority')
			lang.authURI = lang.get_atext(e,'authorityURI')
			lang.valueURI = lang.get_atext(e,'valueURI')

			lang.text = lang.get_etext(e,"languageTerm[@type='text']")
			lang.text_auth = lang.get_atext(e.elements["languageTerm[@type='text']"], 'authority')

			lang.code = lang.get_etext(e,"languageTerm[@type='code']")
			lang.code_auth = lang.get_atext(e.elements["languageTerm[@type='code']"], 'authority')

			puts "\nLANG"
			
			lang.print_vals

			item.languages << lang
		end

# PHYSDESC
	e.elements.each("physicalDescription") do |e|
			pdesc = ModsPhysDesc.new
			pdesc.form = pdesc.get_etext(e, 'form')
			pdesc.extent = pdesc.get_etext(e, 'extent')
			pdesc.note = pdesc.get_etext(e, 'note')
			pdesc.note_type = pdesc.get_atext(e.elements['note'],'type')
			pdesc.qual = pdesc.get_etext(e, 'reformattingQuality')
			pdesc.origin = pdesc.get_etext(e, 'digitalOrigin')

			puts "\nPDESC"
			pdesc.print_vals
		end

			puts "\n\nPRINT ALL"
			item.names.compact! 
			item.titles.compact! 
			item.identifiers.compact! 
			item.genres.compact! 
			item.languages.compact! 
			item.print_vals
	end
end