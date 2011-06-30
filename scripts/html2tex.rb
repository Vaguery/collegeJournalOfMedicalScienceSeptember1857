#encoding: utf-8
Dir.chdir("../html")
pages = Dir.glob("*.htm")

pages.each do |page|
  begin
    newfile = "../tex/" + File.basename(page, ".htm").gsub(/p - /,"")+".tex"

    puts "#{page.to_s} "
    unless File.exist?(newfile)
      puts "   -> #{newfile}"
      str = IO.read(page)
      str.gsub!(/\<br\>/,"\n") # replace explicit line breaks with newlines
      str.gsub!(/\<\/p\>/,"\n") # add extra space between paragraphs
      str.gsub!(/\<p\>/,"") # strip open-¶ markup
      str.gsub!(/^.+\<body\>/m,"") # trim off HTML page info
      str.gsub!(/—/,"---") # replace em-dashes
      str.gsub!(/&quot;/,'"') # revert quotes from entities
      str.gsub!(/\<span class=font\d+\>/,"<FONT?>") # replace ABBYY's <span class=font.> markup with more visible <FONT>
      str.gsub!(/\<\/span\>/,"") # strip closing </span>s
      str.gsub!(/(\n|\s)*<\/body.+$/m,"") # trim off trailing HTML structure
      File.open(newfile, "w") do |tex_file|
        tex_file.puts str.strip + '\endinput'
      end
    else
      puts "   #{newfile} exists"
    end
  end
end