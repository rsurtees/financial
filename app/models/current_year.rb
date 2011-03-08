class CurrentYear < ActiveRecord::Base
  #attr_reader :year, :first_week
  #attr_writer :id, :year, :first_week

  def fill_db
    obj = CurrentYearObj.new
    obj.year = LASTYEAR
    obj.first_week = FIRSTSUNDAY
    puts obj.inspect
    rec = CurrentYear.new do |r|
      r.year = obj.year
      r.first_week = obj.first_week
    end
    rec.save
  end
end
