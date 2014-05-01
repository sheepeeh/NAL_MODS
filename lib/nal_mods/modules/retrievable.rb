require 'rexml/document'
include REXML

module NalMods
	module Retrievable
		attr_reader(:atts)
		attr_accessor(:xml_doc,:xmldoc)

		def xml_doc
			@xml_doc ||= 0 
		end

		def xmldoc
			@xmldoc ||= 0 
		end

		def initialize
			@atts
		end

		def get_etext(parent,element)
			element = parent.elements["#{element}"]
			value = element.text unless ["",nil].include?(element) || ["",nil].include?(element.text) 
		end

		def get_atts(parent,element)
			@atts = {}
			element = parent.elements["#{element}"] unless parent.elements["#{element}"].nil?
			element = nil if parent.elements["#{element}"].nil?
			element.attributes.each { |name, value| atts.store(name,value) unless ["",nil].include?(value) }
		end

		def get_atext(parent,attribute)
			attribute = parent.attributes["#{attribute}"] unless parent.nil?
			value = attribute unless ["",nil].include?(attribute) 
		end


		def csv2ivs(hash,element)
			hash.each do |key, value|
				element.instance_variable_set(key, value)
			end			
		end

		def csv2obj(header, object, target)
			@xmldoc = xmldoc
			parts = []
			parts = header.split("^") unless header.nil?
			
			parts.each do |part|
	            obj = object.new 
				iparts = part.split("%%")
				iv_hash = {}

				iparts.map! do |p|
					p = p.split("&@ ")
					iv_hash.store(p[0].to_s.downcase,p[1])
				end

				#iv_hash.each {|key, value| puts "HASH #{key.to_s} => #{value.to_s}"}

				csv2ivs(iv_hash,obj)

				instance_variables.each do |v|
					val = instance_variable_get(v)
					remove_instance_variable(v) if [nil,""].include?(val)
				end

				#obj.print_vals
				#puts "OBJECT #{obj}"
				target << obj
			end		
		end
	end
end