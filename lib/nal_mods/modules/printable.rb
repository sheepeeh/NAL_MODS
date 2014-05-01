module NalMods
	module Printable

		def xml_doc
			@xml_doc ||= 0 
		end

		def xmldoc
			@xmldoc ||= 0 
		end

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

		def vals2csv(arr)
			objParts = {}
			ct = []
			mem = []

			instance_variables.each do |v|
				val = instance_variable_get(v)
				remove_instance_variable(v) if [nil,""].include?(val)
				v = v.to_s.gsub!("@","")
				objParts.store(v,val) unless [nil,""].include?(val)
				ct << v unless val.nil?
			end
			
			objParts.each do |key, value|
			# 	# case ct.count
			# 	# when 1
			# 	# mem = "#{key.to_s.upcase} => #{value.to_s}" unless value.nil? || ["element","rvalue"].include?(key)
			# 	# else
			# 	# mem = "#{key.to_s.upcase} => #{value.to_s}%" unless value.nil? || ["element","rvalue"].include?(key)
			# 	# end
			# 	# arr << mem
				memm =  "@#{key.to_s.upcase}&@ #{value.to_s}" unless value.nil? || ["element","rvalue"].include?(key)
				mem << memm
			end

			mem = mem.join("%%")
			arr << mem unless mem.empty?
		end
	end
end