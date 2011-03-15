# == Schema Information
# Schema version: 20110223021550
#
# Table name: current_years
#
#  id         :integer         not null, primary key
#  year       :integer(4)      default(2010)
#  first_week :integer(1)      default(3)
#  created_at :datetime
#  updated_at :datetime
#

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
