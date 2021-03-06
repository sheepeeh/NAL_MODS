# About
This library is intended to take hand-created Metadata Object Description Schema (MODS) XML files, convert them to a CSV (pipe-delimited by default) file for use in OpenRefine, and then convert a CSV exported from Open Refine into new, freshly normalized MODS XML files. The classes and methods within it can be used to build custom CSVs for other purposes. 

If you want to create CSVs from MODS for either Internet Archive batch files or Omeka, you might want to take a look at https://github.com/sheepeeh/NAL_metadata instead. The scripts in that repo will eventually be updated to make use of this class library (as well as getting some better documentation).

The majority of this repo is written in/for Ruby 2.0.0. The code has been tested up to Ruby 2.1.1p76. There are a few snippets of JSON and GREL included to make Open Refine less onerous. 

## Caveat
These scripts are still very much in beta, if not alpha. Not all classes have been instantiated, and most classes don't yet have methods for setting attribute values (though those won't be difficult to add, and you can feel free to add them yourself. Getter methods do exist.) The converters currently only convert the elements/attributes I needed them to, namely: 

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

The command line usage also needs to be refined. At the moment, directories and such need to be hardcoded in the relevant line of `/lib/nal_mods/config.rb`. Soon, this will be possible with command line arguments. Similarly, there's no error handling built in yet.

# Usage

After cloning this repository, edit the values in `/lib/nal_mods/config.rb` to specify your source directories and other options.  No external libraries or gems are necessary.

From the `NAL_MODS` directory, use `ruby bin/mods_to_csv.rb` to convert a directory of MODS files to CSV
* This script expects XML to be well-formed

From the `NAL_MODS` directory, use `ruby bin/csv_to_mods.rb` to convert a CSV to MODS files
* This script expects a pipe-delimited CSV file
* The default output directory is __CurrentDir/normalized__
* By default, output files are named __OriginalFilename_normed.xml__
* The most common cause of failure is a stray un-merged cell (if you've split cells in Open Refine for normalization, they must be re-joined before export)

## CSV Output
Your CSV is going to look a little bit strange -- I sacrificed beauty for functionality. You might, for instance, see something like this in the *name* column:

```
@FULL&@ Leahy, Patrick J.%%@GIVEN&@ Patrick%%@FAMILY&@ Leahy%%@AFFIL&@ United States. Congress. Senate%%@ROLE_TEXT&@
addressee%%@ROLE_CODE&@ rcp^@FULL&@ Merrigan, Kathleen (Kathleen Ann), 1959-%%@GIVEN&@ Kathleen%%@FAMILY&@
Merrigan%%@ROLE_TEXT&@ correspondent%%@ROLE_CODE&@ crp
```

What the heck is that?! Well, originally, it was this:
```
<name type="personal" valueURI="http://id.loc.gov/authorities/names/n77013301" authorityURI="http://id.loc.gov/authorities/names" authority="naf">
    <namePart>Leahy, Patrick J.</namePart>
    <namePart type="given">Patrick</namePart>
    <namePart type="family">Leahy</namePart>
    <affiliation>United States. Congress. Senate</affiliation>
    <role>
        <roleTerm type="text" authority="marcrelator">addressee</roleTerm>
    </role>
    <role>
        <roleTerm type="code" authority="marcrelator">rcp</roleTerm>
    </role>
</name>

<name type="personal" valueURI="http://id.loc.gov/authorities/names/no2010071417" authorityURI="http://id.loc.gov/authorities/names" authority="naf">
    <namePart>Merrigan, Kathleen (Kathleen Ann), 1959</namePart>
    <namePart type="given">Kathleen</namePart>
    <namePart type="family">Merrigan</namePart>
    <namePart type="date">1959</namePart>
    <role>
        <roleTerm type="text" authority="marcrelator">correspondent</roleTerm>
    </role>
    <role>
        <roleTerm type="code" authority="marcrelator">crp</roleTerm>
    </role>
</name>
```

The TEXT between **@** and **&@** correspond to MODS elements, and also happen to correspond to the instance variables in our Ruby objects. Luckily, Open Refine doesn't care, because it's consistent. What you _should_ care about are two separators. When the data is in Open Refine, for maximum refinability you should, IN ORDER:

1. Separate all rows you want to normalize by **^**. _(Edit cells -> Split multi-valued cells.. -> ^)_
2. Separate all columns you want to normalize by **%%** _(Edit column -> Split into several columns -> Separator: **%%**)_

Don't want to do that for every column? Go grab the text from **/lib/helpers/json_rows.txt**, click on **Apply** in the **Undo/Redo** column, paste the text, and click **Perform operations.** Then do the same with **json_columns.txt**

If you reverse the order of those operations, bad things will happen.

When you've finished your transformations and want to merge everything back together again, you'll have to work with GREL a little bit. Firstly, Open Refine hates blank values. Try to combine columns with blank values and it says "no." So you need to temporarily assign a value to all blank cells in the columns you need to join. To do that, click **Edit cells -> Transform...** and paste the following code:

`if(isBlank(value), "!NULL!",value)`

After you've done that for all columns which will be joined, join said columns with the following code **(Again in Edit cells -> Transform...)**:

```
if(cells["COLLUMN NAME 1"].value != "!NULL!", if(cells["COLLUMN NAME 2"].value != "!NULL!",cells["COLLUMN NAME 1"].value + "%%" + cells["COLLUMN NAME 2"].value,cells["COLLUMN NAME 1"].value),value)
```

You'll need to repeat this down the line for  your columns. Start by joining Column 1 with Column 2, then join Column 3 with Column 4, and so on down the line.

Finally, get rid of those fake null values like so:
`if(value =="!NULL!",'',value)`

Ta da!

Now export the results using **Export -> Custom tabular exporter...**, set **Download -> Custom separator** to a pipe **|**, and you're good to go.

# Changing it up

## Building a different CSV
Want to create your own CSV? No problem! Here's  how the pieces of `mods_to_csv` work.

* Check in **/lib/nal_mods/classes** to be sure there is a class defined for the element you want to use. Let me  know if it's missing, and I'll look at creating it for you.
* `line 50` builds the headers for the CSV file. Name these however you'd like, but don't use spaces. Fields are delimited with pipes.
* `lines 64 - 90` setup the variables used to send MODS elements/attributes to the CSV.
    - Generally speaking, you should setup blank arrays. `@variable_name = []`
    - It will be easier if your variable names match your headers
    - All variable names must begin with **@**
* Complex elements (elements with children) tend to have a `get_elementname` method. Simple elements like identifier and genre do not, but are pushed into the array using `@array_name << variable_name`
* Basic construction for getting element text:
    ```
    xmldoc.elements.each("mods/topLevelElement") do |e|
        element_name = ModsElement_name.new
        element_name.get_element_name(e)
        element_name.vals2csv(@array_name)
    end
    ```
    For title, this looks like
    ```
    xmldoc.elements.each("mods/titleInfo") do |e|
        title = ModsTitle.new
        title.get_title(e)
        title.vals2csv(@titles)
    end
    ```
(You could also copy-paste the elements you want to use from the base script. They are all commented.)

* ...note that you don't need to do this for child elements. The top-level element will generally grab all children.
* `line 239` remove the default variables, and enter your new variables, separated by commas
* `line_240` do the same thing, but remove the @s and surround the name in quotes (comma comes after the quotes)
* `line 258` change this to match your variable names. If you named your variables and headers the same, you can do this pretty quickly by
    - Copy/pasting `line 50`
    - Add **#{** after the opening quote and **}** before the closing quote
    - Do a Find/Replace All to replace **|** with **}|{**
* That's it!

## Outputting from a customized CSV
Working from `csv_to_mods`
* Check in the class for the element in question in `/lib/nal_mods/classes` to see if it has a `set_text` method.
    - If it does, the new text is set like this:
        ```
        element_array = []
        csv2obj("#{line[:header]}", ModsElementName, element_array)
    
        element_array.each do |element|
            i = element_array.index(element)
            i += 1
    
            xmldoc.elements.each("mods/topLevelElement[#{i}]") do |e|
            element.set_text(e)
            end             
        end
        ```
    - If it doesn't, the new text is set like this:
        
        ```
        xmldoc.elements["mods/elementName"].text = line[:header] unless xmldoc.elements["mods/elementName"].nil?
        ```
* Congratulations on your normalized XML files!

