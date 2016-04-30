head = false
chunks = ''
tables =
  classTab :
    "html" : ""
    "Level" : []
    "BAB" : []
    "for" : []
    "wil" : []
    "ref" : []

bbcode = ''

#parse a string using the passed delimiter
parse = ( str, delim ) ->
  str.split(delim)

#Create the BAB array
baseLoop = ( x ) -> #loop to populate level slots 1-20
  arr = []
  for n in [0..19] ->
    arr[n] = Math.floor( (n+1) * x )
  return

scanChunks  = ( len ) ->
  input = []
  ret = ""

  for n in [0..len-1]
    cn = chunks[n].trim()
    #console.log cn
    ret += if !!cn then formatStr( cn ) else "\n"

  return formatTxt( ret )

formatTxt = ( str ) ->
  arr = parse( str, "\\")
  str = ""

  console.log arr
  for n in [0..arr.length-1]
    console.log arr[n]
    #[[Displayed Link Title|Tiddler Title]]
    str += arr[n].replace( /textit\{(.*)\}/i, "//$1//").replace( /emph|textbf\{(.*)\}/i, "''$1''").replace( /linkskill\{(.*)\}/, "[[$1|$1 Skill]]" ).replace( /ldots\{\}/, "..." )
  return str

formClassTable = ( id, str ) ->
  if not head then #check to see if the "table process" has started yet
    head = true
    tables.classTab = { "Level" : [ "1st", "2nd", "3rd", "4th", "5th", "6th", "7th", "8th", "9th", "10th", "11th", "12th", "13th", "14th", "15th", "16th", "17th", "18th", "19th", "20th" ]

  switch id
    when "goodbab"
      tables.classTab.bab = baseLoop( .75 )
      return
    when "modebab"
      return
    when "poorbab"
      return
    when "goodfor", "goodref", "goodwil"
      return
    when "poorfor", "poorref", "poorwil"
      return
    else
      return console.log "formClassTable ELSE!!!\n"

formatStr = ( str ) ->
  console.log "str::@@:: " + str
  ret = ""
  sca = str.charAt(0)
  console.log "SCA::@@::" + sca
  #if sca is "\\" and sca isnt "%"  #check first char of string for TeX slash
  if sca is "\\" #check first char of string for TeX slash
    console.log "match::@@:: " + str
    matches = str.match(/(\w+)/i)
    found = matches[0]
    switch found
      when "tagline"  #capture the tagline, format then append to string
        found = str.match(/"(.*)"/i)
        str = "<<<.tagline\n" + found[1] + "\n<<<\n"
        ret += str
      when "begin", "end", "raceentry", "classentry" #remove this string as unnecessary
        ret += ""
      when "item" #replace TeX with asterix
        #re = /\\item/i
        str = str.replace /\\item/i, "\n * "
        ret += str
      when "modebab", "goodbab", "goodfor", "goodref", "goodwil", "poorbab", "poorfor", "poorref", "poorwil"
        formClassTable( found, str )
      else  #append string as-is
        #str += ":: ELSE!" + "\n"
        ret += str + "\n"
  else if sca is "%" or not sca
    console.log "BLANKS! :::" + str
    ret += ""
  else
    console.log "OTHER! :::" + str
    ret += "\n&emsp;&emsp;" + str #add any non-tex formatted strings, with indent in front
  # end if
  #return formatTxt( ret )
  return ret

init = () ->
  head = false     # reset the header token
  # newlines into their own strings
  chunks = parse( $('#input').val(), "\n" )

  converted = scanChunks( chunks.length ).trim()
  console.log( converted )

  #$("#result").html(converted)
  $("#output").val(converted)

init()

# trigger content refresh when textarea changes
$("#input").on "change input paste keyup", ->
  init()
  return
