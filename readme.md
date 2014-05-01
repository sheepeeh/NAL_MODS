# About
This library is intended to take hand-created Metadata Object Description Schema (MODS) XML files, convert them to a CSV (pipe-delimited by default) file for use in OpenRefine, and then convert a CSV exported from Open Refine into new, freshly normalized MODS XML files. 

The majority of this repo is written in/for Ruby 2.0.0. There are a few snippets of JSON and GREL included to make Open Refine less onerous. 

## Caveat
These scripts are still very much in beta, if not alpha. Not all classes have been instantiated, and most classes don't yet have methods for setting attribute values (though those won't be difficult to add, and you can feel free to add them yourself. Getter methods do exist.) The converters are currently only convert the elements/attributes I needed them to, namely: 

* identifier
* title > element children
* name > element children
* origin
* place 
* date_copyright
* startdate_copyright
* enddate_copyright
* date_created
* startdate_created
* enddate_created
* date_issued
* startdate_issued
* enddate_issued
* genre
* language
* pdesc_form
* pdesc_extent
* shelf_loc
* table_of_contents
* subject > topic
* subject > time
* subject > genre
* subject > geo
* subject > hgeo
* subject > name
* subject > title

The command line usage also needs to be refined. At the moment, directories and such need to be hardcoded in the relevant /bin file. Soon, this will be possible with command line arguments. Similarly, there's no error handling built in yet.

# Usage

`mods_to_csv` convert a directory of MODS files to CSV
* Expects XML to be well-formed

`csv_to_mods` convert a CSV to MODS files
* This expects a pipe-delimited CSV file
* The default output directory is __CurrentDir/normalized__
* By default, output files are named __OriginalFilename_normed.xml__
* The most common cause of failure is a stray un-merged cell (if you've split cells in Open Refine for normalization, they must be re-joined before export)
