class CreateCurrentYears < ActiveRecord::Migration
  def self.up
    create_table :current_years do |t|
      t.integer :year, :limit => 4, :default => LASTYEAR
      t.integer :first_week, :limit => 1, :default => FIRSTSUNDAY

      t.timestamps
    end

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

  def self.down
    drop_table :current_years
  end
end

class CurrentYearObj
  attr_reader :id, :year, :first_week
  attr_writer :id, :year, :first_week

  def initialize()
    @id = @year = @first_week = nil
    @created = Date.today
  end

  def to_s()
    "#{@id}\t#{@year}\t#{@first_week}\t#{@created}"
  end
end
