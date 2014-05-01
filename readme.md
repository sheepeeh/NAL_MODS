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

When you've finished your transformations and want to merge everything back together again, you'll have to work with GREL a little bit. Firstly, Open Refine hates blank values. Try to combine columun with blank values and it says "no." So you need to temporarily assign a value to all blank cells in columns you need to join. To do that, click **Edit cells -> Transform...** and paste the following code:

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
