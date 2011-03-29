module ApplicationHelper

  # Return a title on a per-page basis.
  def title
    base_title = "NBC Financial Giving Records"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def testrun
    outfile = File.open("TestFile.txt","w")
    puts "This is the first line."
    puts "This is the last line."
    outfile.close
  end

end
