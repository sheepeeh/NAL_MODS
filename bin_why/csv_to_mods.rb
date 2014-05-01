require 'csv'
require 'benchmark'
require 'rexml/document'
include REXML

# Mixins
require_relative '../lib/nal_mods/modules/retrievable'
require_relative '../lib/nal_mods/modules/printable'
require_relative '../lib/nal_mods/modules/walkable'

# Classes
require_relative '../lib/nal_mods/classes/abstract'
require_relative '../lib/nal_mods/classes/access'
require_relative '../lib/nal_mods/classes/genre'
require_relative '../lib/nal_mods/classes/identifier'
require_relative '../lib/nal_mods/classes/language'
require_relative '../lib/nal_mods/classes/location'
require_relative '../lib/nal_mods/classes/name'
require_relative '../lib/nal_mods/classes/note'
require_relative '../lib/nal_mods/classes/origin'
require_relative '../lib/nal_mods/classes/physdesc'
require_relative '../lib/nal_mods/classes/related'
require_relative '../lib/nal_mods/classes/resourcetype'
require_relative '../lib/nal_mods/classes/subject'
require_relative '../lib/nal_mods/classes/title'
require_relative '../lib/nal_mods/classes/toc'

include NalMods::Printable
include NalMods::Retrievable
include NalMods::Walkable


module NalMods
	def build_mods(from_csv)
		include NalMods
		btime = Benchmark.realtime {

		CSV.foreach(from_csv, :headers => true, :header_converters => :symbol, :col_sep => "|") do |line|

			# Change ../examples/xml to the actual source directory
			xmldoc = (Document.new File.new "../examples/xml/#{line[:original_filename]}") if File.exists?("../examples/xml/#{line[:original_filename]}")
			xmldoc.context[:attribute_quote] = :quote

			stime = Time.now
			puts "#{stime}> Converting #{line[:original_filename]}"

			# Set element text to normalized values
			## ID
			xmldoc.elements["mods/identifier"].text = line[:identifier] unless xmldoc.elements["mods/identifier"].nil?

			## TITLE
			titles = []
			csv2obj("#{line[:title]}", ModsTitle, titles)
			titles.uniq!

			titles.each do |title|
				i = titles.index(title)
				i += 1
				
				xmldoc.elements.each("mods/titleInfo[#{i}]") do |e|
					title.set_text(e)
				end				
			end

			## NAMES
			names = []
			csv2obj("#{line[:name]}",ModsName,names)
			names.uniq!

			names.each do |name|
				i = names.index(name)
				i += 1
				
				xmldoc.elements.each("mods/name[#{i}]") do |e|
					name.set_text(e)
				end				
			end
			
			## GENRE
			xmldoc.elements["mods/genre"].text = line[:genre] unless xmldoc.elements["mods/genre"].nil?

			## ORIGIN INFO
			origins = []
			csv2obj("#{line[:origin]}", ModsOrigin, origins)
			origins = nil if origins.empty?
			origins = origins.fetch(0) unless origins.nil?
			
			date_copyright = []
			csv2obj("#{line[:date_copyright]}", ModsOrigin::Copyright, date_copyright)
			date_copyright.uniq!
			date_copyright = nil if date_copyright.empty?
			date_copyright = date_copyright.fetch(0) unless date_copyright.nil?
			

			date_created = []
			csv2obj("#{line[:date_created]}", ModsOrigin::Created, date_created)
			date_created.uniq!
			date_created = nil if date_created.empty?
			date_created = date_created.fetch(0) unless date_created.nil?
			
			date_issued = []
			csv2obj("#{line[:date_issued]}", ModsOrigin::Issued, date_issued)
			date_issued.uniq!
			date_issued = nil if date_issued.empty?
			date_issued = date_issued.fetch(0) unless date_issued.nil?
			

			xmldoc.elements.each("mods/originInfo") do |e|
				origins.set_text(e) unless origins.nil?
				date_copyright.set_text(e) unless date_copyright.nil?
				date_created.set_text(e) unless date_created.nil?
				date_issued.set_text(e) unless date_issued.nil?
			end				
			
			## LANGUAGE
			languages = []
			csv2obj("#{line[:languages]}", ModsLang, languages)
			languages.uniq!

			languages.each do |lang|
				i = languages.index(lang)
				i += 1
				
				xmldoc.elements.each("mods/language[#{i}]") do |e|
					lang.set_text(e)
				end				
			end

			## PHYSICAL DESCRIPTION
			pdescs = []
			csv2obj("#{line[:pdesc_form]}", ModsPhysDesc, pdescs)
			pdescs.uniq!

			pdescs.each do |pdesc|
				i = pdescs.index(pdesc)
				i += 1
				
				xmldoc.elements.each("mods/physicalDescription") do |e|
					pdesc.set_text(e)
				end				
			end

			## SUBJECTS		
			topics = []
			csv2obj("#{line[:subj_topic]}", ModsSubject, topics)
			topics.uniq!

			topics.each do |topic|
				i = topics.index(topic)
				i += 1
				
				xmldoc.elements.each("//topic[#{i}]") do |e|
					topic.set_topic(e)
				end				
			end

			genres = []
			csv2obj("#{line[:subj_genre]}", ModsSubject, genres)
			genres.uniq!

			genres.each do |genre|
				i = genres.index(genre)
				i += 1
				
				xmldoc.elements.each("mods/subject/genre[#{i}]") do |e|
					genre.set_genre(e)
				end				
			end

			geos = []
			csv2obj("#{line[:subj_geo]}", ModsSubject, geos)
			geos.uniq!

			geos.each do |geo|
				i = geos.index(geo)
				i += 1
				
				xmldoc.elements.each("mods/subject/geographic[#{i}]") do |e|
					geo.set_geo(e)
				end				
			end

			times = []
			csv2obj("#{line[:subj_time]}", ModsSubject, times)
			times.uniq!

			times.each do |time|
				i = times.index(time)
				i += 1
				
				xmldoc.elements.each("mods/subject/temporal[#{i}]") do |e|
					time.set_time(e)
				end				
			end

			hgeos = []
			csv2obj("#{line[:subj_hgeo]}", ModsSubject::HGeo, hgeos)
			hgeos.uniq!

			hgeos.each do |hgeo|
				i = hgeos.index(hgeo)
				i += 1
				
				xmldoc.elements.each("mods/subject/hierarchicalGeographic[#{i}]") do |e|
					hgeo.set_hgeo(e)
				end				
			end

			subj_titles = []
			csv2obj("#{line[:subj_title]}", ModsTitle, subj_titles)
			subj_titles.uniq!

			subj_titles.each do |subj_title|
				i = subj_titles.index(subj_title)
				i += 1
				
				xmldoc.elements.each("mods/subject/titleInfo[#{i}]") do |e|
					subj_title.set_text(e)
				end				
			end

			subj_names = []
			csv2obj("#{line[:subj_name]}",ModsName,subj_names)
			subj_names.uniq!

			subj_names.each do |subj_name|
				i = subj_names.index(subj_name)
				i += 1
				
				xmldoc.elements.each("mods/subj_name[#{i}]") do |e|
					subj_name.set_text(e)
				end				
			end

			## TABLE OF CONTENTS

			tocs = []
			csv2obj("#{line[:table_of_contents]}", ModsToc, tocs)
			tocs.uniq!

			tocs.each do |toc|
				i = tocs.index(toc)
				i += 1
				
				xmldoc.elements.each("mods/tableOfContents[#{i}]") do |e|
					toc.set_text(e)
				end				
			end

			## PHYSICAL LOCATION
			locations = []
			csv2obj("#{line[:shelf_loc]}", ModsLocation, locations)
			locations.uniq!

			locations.each do |location|
				i = locations.index(location)
				i += 1
				
				xmldoc.elements.each("mods/location[#{i}]") do |e|
					location.set_text(e)
				end				
			end



		# Print to file_normed.xml

			formatter = Formatters::Default.new

			File.open("../examples/#{line[:new_filename]}","w") do |result| # Change ../examples to desired output directory
				formatter.write(xmldoc,result)
			end
		end
		}
		etime = Time.now
		puts "#{etime}> Time elapsed: #{btime}"
	end
end

# Specify the CSV to  use.
include NalMods
build_mods("../examples/example.csv")