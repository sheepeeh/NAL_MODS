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



	def pjoin(arr)
		arr.compact!
		arr = arr.join("^")
	end

	def build_csv(target_dir)
		
		btime = Benchmark.realtime {

		Dir.mkdir("../examples/normalized") unless Dir.exists?("../examples/normalized")
		dseed = File.basename("#{target_dir}")
		f = File.open("../examples/#{dseed}_to_norm.csv","a")

		# Print header
		f.puts "original_filename|new_filename|identifier|title|name|origin|place|date_copyright|startdate_copyright|enddate_copyright|date_created|startdate_created|enddate_created|date_issued|startdate_issued|enddate_issued|genre|language|pdesc_form|pdesc_extent|shelf_loc|table_of_contents|subj_topic|subj_time|subj_genre|subj_geo|subj_hgeo|subj_name|subj_title"

		Dir.glob("#{target_dir}/*.xml").each do |xml_file|

			stime = Time.now
			puts "#{stime}> Converting #{xml_file}"

			# Setup files
			xmldoc = (Document.new File.new "#{xml_file}")
			original_filename = File.basename(xml_file)
			fseed = File.basename(xml_file,".xml")
			new_filename = "../examples/normalized/#{fseed}_normed.xml"


			# Create element arrays/variables
			@identifiers = []
			@titles = []
			@names = []
			@origins = []
			@date_copyright = []
			@startdate_copyright = nil
			@enddate_copyright = nil
			@date_created = []
			@startdate_created = nil
			@enddate_created = nil
			@date_issued = []
			@startdate_issued = nil
			@enddate_issued = nil
			@genres = []
			@languages = []
			@pdescs = []
			@pdesc_extent = nil
			@shelf_loc = []
			@table_of_contents = []
			@subj_topics = []
			@subj_genres = []
			@subj_times = []
			@subj_geos = []
			@subj_hgeos = []
			@subj_names = []
			@subj_titles = []

			# RETRIEVE MODS DATA

			## ID
			xmldoc.elements.each("mods/identifier") do |e|
				@identifiers << e.text			
			end

			

			## TITLE
			
		 	xmldoc.elements.each("mods/titleInfo") do |e|
				title = ModsTitle.new
				title.get_title(e)
				title.vals2csv(@titles)
			end

			

			## NAME
			xmldoc.elements.each("mods/name") do |e|
				name = ModsName.new
				name.get_name(e)
				name.vals2csv(@names)
			end


			
			## GENRE
			xmldoc.elements.each("mods/genre") do |e|
				@genres << e.text
			end


			## ORIGIN INFO
			xmldoc.elements.each("mods/originInfo") do |e|
				origin = ModsOrigin.new
				origin.get_publisher(e)
				origin.get_place(e)
				origin.get_issuance(e)
				origin.vals2csv(@origins)

				copyright = ModsOrigin::Copyright.new
				copyright.get_date(e)
				copyright.vals2csv(@date_copyright)

				created = ModsOrigin::Created.new
				created.get_date(e)
				created.vals2csv(@date_created)

				issued = ModsOrigin::Issued.new
				issued.get_date(e)
				issued.vals2csv(@date_issued)
			end





			## LANGUAGE
			xmldoc.elements.each("mods/language") do |e|
				lang = ModsLang.new
				lang.get_ltext(e)
				lang.get_lcode(e)
				lang.vals2csv(@languages)			
			end


			## PHYSICAL DESCRIPTION
			xmldoc.elements.each("mods/physicalDescription") do |e|
				pdesc = ModsPhysDesc.new
				pdesc.get_pdesc(e)
				pdesc.vals2csv(@pdescs)
			end

			

			## SUBJECTS
			xmldoc.elements.each("mods/subject/topic") do |e|
				subj_topic = ModsSubject.new
				subj_topic.get_topic(e)
				subj_topic.vals2csv(@subj_topics)
			end



			xmldoc.elements.each("mods/subject") do |e|
				subj_genre = ModsSubject.new
				subj_genre.get_genre(e)
				subj_genre.vals2csv(@subj_genres)
			end



			xmldoc.elements.each("mods/subject") do |e|
				geo = ModsSubject.new
				geo.get_geo(e)
				geo.vals2csv(@subj_geos)
			end

			xmldoc.elements.each("mods/subject") do |e|
				time = ModsSubject.new
				time.get_time(e)
				time.vals2csv(@subj_times)
			end



			xmldoc.elements.each("mod/subject/hierarchicalGeographic") do |h|
				hgeo = ModsSubject::HGeo.new
				hgeo.get_hgeo(h)
				hgeo.vals2csv(@subj_hgeos)
			end



			xmldoc.elements.each("mods/subject/name") do |e|
				name = ModsName.new
				name.get_name(e)
				name.vals2csv(@subj_names)
			end


			xmldoc.elements.each("mods/subject/titleInfo") do |e|
				title = ModsTitle.new
				title.get_title(e)
				title.vals2csv(@subj_titles)
			end



			## TABLE OF CONTENTS
			xmldoc.elements.each("mods/tableOfContents") do |e|
				toc = ModsToc.new
				toc.get_toc(e)
				toc.vals2csv(@table_of_contents)
			end



			## PHYSICAL LOCATION
			xmldoc.elements.each("mods/location") do |e|
				location = ModsLocation.new
				location.get_loc(e)
				location.vals2csv(@shelf_loc)	
			end

			element_arrays = [@identifiers, @titles, @names, @origins, @date_copyright, @date_created, @date_issued, @genres, @languages, @pdescs, @shelf_loc, @table_of_contents, @subj_topics, @subj_genres, @subj_times, @subj_geos, @subj_hgeos, @subj_names, @subj_titles]
			element_names = ["identifiers", "titles", "names", "origins", "date_copyright", "date_created", "date_issued", "genres", "languages", "pdescs", "shelf_loc", "table_of_contents", "subj_topics", "subj_genres", "subj_times", "subj_geos", "subj_hgeos", "subj_names", "subj_titles"]

			element_arrays.map! do |e_arr|
				pjoin(e_arr) unless e_arr.nil?
			end

			element_hash = {}
			element_names.each do |name|
				i = element_names.index(name)
				k = name
				v = element_arrays[i]
				element_hash.store(k,v)
			end	

			element_hash.each do |key, value|
				instance_variable_set("@#{key}",value)
			end		

			f.puts "#{original_filename}|#{new_filename}|#{@identifiers}|#{@titles}|#{@names}|#{@origins}||#{@date_copyright}|#{@startdate_copyright}|#{@enddate_copyright}|#{@date_created}|#{@startdate_created}|#{@enddate_created}|#{@date_issued}|#{@startdate_issued}|#{@enddate_issued}|#{@genres}|#{@languages}|#{@pdescs}||#{@shelf_loc}|#{@table_of_contents}|#{@subj_topics}|#{@subj_times}|#{@subj_genres}|#{@subj_geos}|#{@subj_hgeos}|#{@subj_names}|#{@subj_titles}"
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