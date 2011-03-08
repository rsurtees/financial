class CreateWeekdates < ActiveRecord::Migration

  def self.up
    create_table :weekdates, :force => true do |t|
      t.integer :qmw, :limit => 3, :default => 111
      t.integer :year, :limit => 5, :default => 2009
      t.integer :quarter, :limit => 2, :default => 1
      t.integer :month, :limit => 2, :default => 1
      t.integer :day, :limit => 2, :default => 1
      t.integer :week, :limit => 2, :default => 1
      t.string :date_string, :limit => 20

      t.timestamps
    end

    current_year = CurrentYear.find(:first)
    week_one = Weekdate.new
    week_one.year = current_year.year
    week_one.day = current_year.first_week
    week_one.create_year_first_year(week_one)

  end

  def self.down
    drop_table :weekdates
  end
end

