require 'rexml/document'
include REXML
#require_relative 'mods_test'	


module REXML
	# Visit all children of  this node, but don't recurse to their children
	def each_child_element(&block)
		self.elements.each {|node|
			block.call(node)
		}
	end
end

module NalMods
	module Walkable
		#include ModsFile
		@es = []
		attr_accessor(:xml_doc)

		def xml_doc
			    @xml_doc ||= 0 
		end

		def self.es
			@es
		end

		def print_first_children (parent)
			#printing the tags of the immediate children.
			@xmldoc.elements.each("parent") do |element|		
				element.each_child_element do |childElement|
					print "[", childElement.name.to_s, "]"
				end
			end
		end

		def recurse_element(the_element)

			the_element.each_child_element do |childElement|
				puts the_element.name.to_s
				print  "#{childElement.name.to_s}\n\n"
				recurse_element(childElement)
			end
		end

		def count_elements(the_element)
			count = 0
			@xml_doc.each_element(the_element) { |n| count = count+1 }
			puts "#{the_element} count: #{count}"
		end

		def recurse_text(the_element)
			if Walkable.es.count == 0
				parent = {"top level" => the_element.name.to_s }
				the_element.attributes.each { |name, value| parent.store(name,value) }

				parent.each do |key, value|
					puts "#{key.to_s.capitalize}: #{value.to_s}" unless  [nil,""].include?(value)
				end
				Walkable.es << the_element
			end

			
			puts "\n"

			the_element.each_child_element do |childElement|
				child = {}
				child.store("parent", the_element.name.to_s)
				child.store("name",childElement.name.to_s)
				childElement.attributes.each { |name, value| child.store(name,value) }
				child.store("text",childElement.text.to_s)

				child.each do |key, value|
					puts "#{key.to_s.capitalize}: #{value.to_s}" unless [nil,""].include?(value)
				end

				puts "-" * 10
				puts "\n"

				recurse_text(childElement)
			end
		end
	end
end


