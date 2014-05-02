
@script_options = {

	# Set the location of your source MODS files
	:mods_source => "./my_xml",
	
	# Set the location and filename for the CSV created from the source MODS files 
	:csv_destination => "./my_xml/my_xml_to_norm.csv",

	
	#Set the location for normalized files	
	:normalized_dir => "./normalized",

	
	# Set filename suffix for the normalized files. Set to "" to use the original filename
	:normalized_suffix => "_normed"

}
