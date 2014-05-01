require 'rexml/document'
include REXML
require_relative '../modules/retrievable'
require_relative '../modules/printable'

module NalMods
	class ModsLang
		attr_accessor(:auth,:authURI,:valueURI,:text,:text_auth,:code,:code_auth)
		include Printable
		include Retrievable

		def initialize
			@auth = nil
			@authURI = nil
			@valueURI = nil
			@text = nil
			@text_auth = nil
			@code = nil
			@code_auth = nil
		end

		def get_ltext(e)
			@text = get_etext(e, "languageTerm[@type='text']")
		end

		def get_lcode(e)
			@code = get_etext(e, "languageTerm[@type='code']")
		end

		def set_text(e)
			e.elements["languageTerm[@type='text']"].text = @text unless e.elements["languageTerm[@type='text']"].nil?
			e.elements["languageTerm[@type='code']"].text = @code unless e.elements["languageTerm[@type='code']"].nil?
		end
	end


	if __FILE__ == $0
		xmldoc = (Document.new File.new "test.xml")
	 	
	 	xmldoc.elements.each("mods/language") do |e|
			lang = ModsLang.new
			lang.auth = lang.get_atext(e,'authority')
			lang.authURI = lang.get_atext(e,'authorityURI')
			lang.valueURI = lang.get_atext(e,'valueURI')

			lang.text = lang.get_etext(e,"languageTerm[@type='text']")
			lang.text_auth = lang.get_atext(e.elements["languageTerm[@type='text']"], 'authority')

			lang.code = lang.get_etext(e,"languageTerm[@type='code']")
			lang.code_auth = lang.get_atext(e.elements["languageTerm[@type='code']"], 'authority')

			lang.print_vals
		end
	end
end