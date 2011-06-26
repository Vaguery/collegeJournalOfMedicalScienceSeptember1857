require 'timeout'

Dir.chdir("../orig")
pages = Dir.glob("*.tif")

@time_limit = 60

pages.each do |page|
  begin
    Timeout::timeout(@time_limit) do |timeout_length|
      newfile = "../screen/" + File.basename(page, ".tif").gsub(/\s/,"_")+".jpg"
  
      puts page.to_s
      puts newfile
      unless File.exist?(newfile)
        system("convert #{page.gsub(" ","\ ")} -auto-level -deskew 50% -despeckle -white-threshold 70% -black-threshold 50% -adaptive-resize 35% -fuzz 50% -trim -bordercolor 'white' -border 20 -density 300 -colorspace Gray -quality 50%  #{newfile}") # 
      end
    end
  rescue Timeout::Error
    puts "#{page} timed out after #{@time_limit} seconds"
  end
end