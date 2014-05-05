module NalMods
	module Printable

		def xml_doc
			@xml_doc ||= 0 
		end

		def xmldoc
			@xmldoc ||= 0 
		end
# Print values to stdout
		def print_vals
			objParts = {}

			instance_variables.each do |v|
				val = instance_variable_get(v)
				remove_instance_variable(v) if val == nil || val == ""
				v = v.to_s.gsub!("@","")
				objParts.store(v,val) unless val.nil?
			end

			objParts.each do |key, value|
				puts "#{key.to_s.capitalize}: #{value.to_s}" unless value.nil? || ["element","rvalue"].include?(key)
			end
		end
# Send values to CSV for Open Refine
		def vals2csv(arr)
			objParts = {}
			mem = []

			instance_variables.each do |v|
				val = instance_variable_get(v)
				remove_instance_variable(v) if [nil,""].include?(val)
				v = v.to_s.gsub!("@","")
				objParts.store(v,val) unless [nil,""].include?(val)
			end
			
			objParts.each do |key, value|
				memm =  "@#{key.to_s.upcase}&@ #{value.to_s}" unless value.nil? || ["element","rvalue"].include?(key)
				mem << memm
			end

			mem = mem.join("%%")
			arr << mem unless mem.empty?
		end
# Send values to CSV for Omeka CSV Import
		def vals2omeka(var)
			objParts = {}
			mem = []

			instance_variables.each do |v|
				val = instance_variable_get(v)
				remove_instance_variable(v) if [nil,""].include?(val)
				v = v.to_s.gsub!("@","")
				objParts.store(v,val) unless [nil,""].include?(val)
			end
			
			objParts.each do |key, value|
				mem =  "#{value.to_s}" unless ["",nil].include?(value)
				arr << mem unless mem.empty?
			end
		end

	end
end