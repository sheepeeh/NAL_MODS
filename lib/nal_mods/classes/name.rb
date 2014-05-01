require 'rexml/document'
require_relative '../modules/retrievable'
require_relative '../modules/printable'
require_relative '../modules/walkable'
include REXML

module NalMods
	class ModsName
		attr_accessor(:type, :authority, :authURI, :valueURI, :full, :given, :family, :role_text, :role_code, :affil, :names)
		include Retrievable
		include Printable
		include Walkable

		def initialize
			@type = nil
			@authority = nil
			@authURI = nil
			@valueURI = nil
			@full = nil
			@given = nil
			@family = nil
			@affil = nil
			@role_text = nil
			@role_code = nil
		end

		def parts_to_full
			@full = "#{@family}, #{@given}" if @full.nil?
		end

		def get_name(e)
			
				@full = get_etext(e,"namePart[not(@*)]")
				@given = get_etext(e,"namePart[@type='given']")
				@family = get_etext(e,"namePart[@type='family']")
				@affil = get_etext(e,"affiliation")

				@role_text = get_etext(e,"role/roleTerm[@type='text']")
				@role_code = get_etext(e,"role/roleTerm[@type='code']")

				@role_text = @role_text.downcase  unless @role_text.nil?
				@role_code = @role_code.downcase unless @role_code.nil?
		end

		def set_text(e)
			e.elements["namePart[not(@*)]"].text = @full unless e.elements["namePart[not(@*)]"].nil?
			e.elements["namePart[@type='given']"].text = @given  unless e.elements["namePart[@type='given']"].nil?
			e.elements["namePart[@type='family']"].text = @family unless e.elements["namePart[@type='family']"].nil?
			e.elements["affiliation"].text = @affil unless e.elements["affiliation"].nil?
	 
	 
			e.elements["role/roleTerm[@type='text']"].text = @role_text unless e.elements["role/roleTerm[@type='text']"].nil?
			e.elements["role/roleTerm[@type='code']"].text = @role_code unless e.elements["role/roleTerm[@type='code']"].nil?
		end
	end
end





if __FILE__ == $0
	xmldoc = (Document.new File.new "test.xml")
	names =[]
	xmldoc.elements.each("mods/name") do |e|
		
		name = ModsName.new
		name.get_name(e)
		name.print_vals
		name.vals2csv(names)
		names.each do |n|
			puts n
		end

		# name.type = name.get_atext(e,"type")
		# name.authority = name.get_atext(e,"authority")
		# name.authURI = name.get_atext(e,"authorityURI")
		# name.valueURI = name.get_atext(e,"valueURI")
		
		# name.full = name.get_etext(e,"namePart[not(@*)]")
		# name.given = name.get_etext(e,"namePart[@type='given']")
		# name.family = name.get_etext(e,"namePart[@type='family']")
		# name.affil = name.get_etext(e,"affiliation")

		# name.role_text = name.get_etext(e,"role/roleTerm[@type='text']")
		# name.role_code = name.get_etext(e,"role/roleTerm[@type='code']")

		# name.print_vals

		# puts "\nTEXT"
		# name.recurse_text(xmldoc.elements["mods/name"])

		# puts "\nCOUNT\n"
		
		# name.xml_doc = xmldoc
		# name.count_elements("mods/name")
		# puts name.xml_doc
	# count = 0
	# xmldoc.each_element("mods/name") { |n| count = count+1 }
	# puts count
	end	


end