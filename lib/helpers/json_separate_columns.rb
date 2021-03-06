fields = ["original_filename","new_filename","identifier","title","name","origin","place","date_copyright","startdate_copyright","enddate_copyright","date_created","startdate_created","enddate_created","date_issued","startdate_issued","enddate_issued","genre","language","pdesc_form","pdesc_extent","shelf_loc","table_of_contents","subj_topic","subj_time","subj_genre","subj_geo","subj_hgeo","subj_name","subj_title"]

f = File.new("json_columns.txt","a")
f.puts "["
fields.each do |field|
	output =	
"\n{
    \"op\": \"core/column-split\",
    \"description\": \"Split column #{field} by separator\",
    \"engineConfig\": {
      \"facets\": [],
      \"mode\": \"record-based\"
    },
    \"columnName\": \"#{field}\",
    \"guessCellType\": true,
    \"removeOriginalColumn\": true,
    \"mode\": \"separator\",
    \"separator\": \"%\",
    \"regex\": false,
    \"maxColumns\": 0
  },"
	f.puts output
end
f.puts "]"
f.close