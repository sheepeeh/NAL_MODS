require 'csv'
require 'rexml/document'
require 'benchmark'

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
include REXML

module NalMods
	def build_csv(target_dir)
		
		btime = Benchmark.realtime {

		Dir.mkdir("../examples/normalized") unless Dir.exists?("./normalized") # Change to whatever you want your normalized file directory to be.
		dseed = File.basename("#{target_dir}")
		f = File.open("../examples/#{dseed}_to_norm.csv","a") # Change ../examples to where you want the CSV to be output

		# Print header to CSV
		f.puts "original_filename|new_filename|identifier|title|name|origin|place|date_copyright|startdate_copyright|enddate_copyright|date_created|startdate_created|enddate_created|date_issued|startdate_issued|enddate_issued|genre|language|pdesc_form|pdesc_extent|shelf_loc|table_of_contents|subj_topic|subj_time|subj_genre|subj_geo|subj_hgeo|subj_name|subj_title"

		Dir.glob("#{target_dir}/*.xml").each do |xml_file|

			stime = Time.now
			puts "#{stime}> Converting #{xml_file}"

			# Setup files
			xmldoc = (Document.new File.new "#{xml_file}")
			original_filename = File.basename(xml_file)
			fseed = File.basename(xml_file,".xml")
			new_filename = "../examples/normalized/#{fseed}_normed.xml" # Change to reflect desired location/filename for normalized files.


			# Create element arrays/variables
			identifiers = []
			titles = []
			names = []
			origins = []
			date_copyright = []
			startdate_copyright = nil
			enddate_copyright = nil
			date_created = []
			startdate_created = nil
			enddate_created = nil
			date_issued = []
			startdate_issued = nil
			enddate_issued = nil
			genres = []
			languages = []
			pdescs = []
			pdesc_extent = nil
			shelf_loc = []
			table_of_contents = []
			subj_topics = []
			subj_genres = []
			subj_times = []
			subj_geos = []
			subj_hgeos = []
			subj_names = []
			subj_titles = []

			# RETRIEVE MODS DATA

			## ID
			xmldoc.elements.each("mods/identifier") do |e|
				identifiers << e.text			
			end

			identifiers.compact!
			identifiers = identifiers.join("^")

			## TITLE
			
		 	xmldoc.elements.each("mods/titleInfo") do |e|
				title = ModsTitle.new
				title.get_title(e)
				title.vals2csv(titles)
			end

			titles.compact!
			titles = titles.join("^")
			

			## NAME
			xmldoc.elements.each("mods/name") do |e|
				name = ModsName.new
				name.get_name(e)
				name.vals2csv(names)
			end

			names.compact!
			names = names.join("^")

			
			## GENRE
			xmldoc.elements.each("mods/genre") do |e|
				genres << e.text
			end

			genres.compact!
			genres = genres.join("^")

			## ORIGIN INFO
			xmldoc.elements.each("mods/originInfo") do |e|
				origin = ModsOrigin.new
				origin.get_publisher(e)
				origin.get_place(e)
				origin.get_issuance(e)
				origin.vals2csv(origins)

				copyright = ModsOrigin::Copyright.new
				copyright.get_date(e)
				copyright.vals2csv(date_copyright)

				created = ModsOrigin::Created.new
				created.get_date(e)
				created.vals2csv(date_created)

				issued = ModsOrigin::Issued.new
				issued.get_date(e)
				issued.vals2csv(date_issued)
			end

			origins.compact! 
			origins = origins.join("^")

			date_copyright.compact!
			date_created.compact!
			date_issued.compact!

			date_copyright = date_copyright.join("^")
			date_created = date_created.join("^")
			date_issued = date_issued.join("^")



			## LANGUAGE
			xmldoc.elements.each("mods/language") do |e|
				lang = ModsLang.new
				lang.get_ltext(e)
				lang.get_lcode(e)
				lang.vals2csv(languages)			
			end
			languages.compact!
			languages = languages.join("^")


			## PHYSICAL DESCRIPTION
			xmldoc.elements.each("mods/physicalDescription") do |e|
				pdesc = ModsPhysDesc.new
				pdesc.get_pdesc(e)
				pdesc.vals2csv(pdescs)
			end
			pdescs.compact!
			pdescs = pdescs.join("^")
			

			## SUBJECTS
			xmldoc.elements.each("mods/subject/topic") do |e|
				subj_topic = ModsSubject.new
				subj_topic.get_topic(e)
				subj_topic.vals2csv(subj_topics)
			end

			subj_topics.compact!
			subj_topics = subj_topics.join("^") unless subj_topics.nil?

			xmldoc.elements.each("mods/subject") do |e|
				subj_genre = ModsSubject.new
				subj_genre.get_genre(e)
				subj_genre.vals2csv(subj_genres)
			end

			subj_genres.compact!
			subj_genres = subj_genres.join("^") unless subj_genres.nil?

			xmldoc.elements.each("mods/subject") do |e|
				geo = ModsSubject.new
				geo.get_geo(e)
				geo.vals2csv(subj_geos)
			end

			subj_geos.compact!
			subj_geos = subj_geos.join("^")	

			xmldoc.elements.each("mods/subject") do |e|
				time = ModsSubject.new
				time.get_time(e)
				time.vals2csv(subj_times)
			end

			subj_times.compact!
			subj_times =  subj_times.join("^") unless subj_times.nil?

			xmldoc.elements.each("mod/subject/hierarchicalGeographic") do |h|
				hgeo = ModsSubject::HGeo.new
				hgeo.get_hgeo(h)
				hgeo.vals2csv(subj_hgeos)
			end

			subj_hgeos.compact!
			subj_hgeos = subj_hgeos.join("^")

			xmldoc.elements.each("mods/subject/name") do |e|
				name = ModsName.new
				name.get_name(e)
				name.vals2csv(subj_names)
			end

			subj_names.compact!
			subj_names = subj_names.join("^")

			xmldoc.elements.each("mods/subject/titleInfo") do |e|
				title = ModsTitle.new
				title.get_title(e)
				title.vals2csv(subj_titles)
			end

			subj_titles.compact!
			subj_titles = subj_titles.join("^")

			## TABLE OF CONTENTS
			xmldoc.elements.each("mods/tableOfContents") do |e|
				toc = ModsToc.new
				toc.get_toc(e)
				toc.vals2csv(table_of_contents)
			end

			table_of_contents.compact!
			table_of_contents = table_of_contents.join("^")

			## PHYSICAL LOCATION
			xmldoc.elements.each("mods/location") do |e|
				location = ModsLocation.new
				location.get_loc(e)
				location.vals2csv(shelf_loc)	
			end
			shelf_loc.compact!
			shelf_loc = shelf_loc.join("^")

			# Prints element text to CSV
			f.puts "#{original_filename}|#{new_filename}|#{identifiers}|#{titles}|#{names}|#{origins}||#{date_copyright}|#{startdate_copyright}|#{enddate_copyright}|#{date_created}|#{startdate_created}|#{enddate_created}|#{date_issued}|#{startdate_issued}|#{enddate_issued}|#{genres}|#{languages}|#{pdescs}||#{shelf_loc}|#{table_of_contents}|#{subj_topics}|#{subj_times}|#{subj_genres}|#{subj_geos}|#{subj_hgeos}|#{subj_names}|#{subj_titles}"
		end
		f.close
			}
		etime = Time.now
		puts "#{etime}> Time elapsed: #{btime}"
	end
end

# Specify a directory of MODS.xml files
include NalMods
build_csv("../examples/xml")