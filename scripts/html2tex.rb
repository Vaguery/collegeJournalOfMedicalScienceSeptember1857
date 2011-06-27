Dir.chdir("../html")
pages = Dir.glob("*.htm")

pages.each do |page|
  begin
    newfile = "../tex/" + File.basename(page, ".htm").gsub(/p - /,"")+".tex"

    puts "#{page.to_s} "
    unless File.exist?(newfile)
      puts "   -> #{newfile}"
      str = IO.read(page)
      str.gsub!(/\<br\>/,"\n")
      str.gsub!(/\<\/p\>/,"\n")
      str.gsub!(/\<p\>/,"")
      str.gsub!(/^.+\<body\>/m,"")
      str.gsub!(/(\n|\s)*<\/body.+$/m,"")
      File.open(newfile, "w") do |tex_file|
        tex_file.puts str.strip
      end
    else
      puts "   #{newfile} exists"
    end
  end
end