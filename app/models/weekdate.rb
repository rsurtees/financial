class Numeric
  def ordinal
    self.to_s + ((10...20).include?(self) ? 'th' : %w{ th st nd rd th th th th th th }[self % 10])
  end
end

class Weekdate < ActiveRecord::Base
  has_many :donations


  #
  # Determine the number of days in each month
  # Returns an arrary with Jan = [1] with the days in the month
  #
  def month_days
    puts "self: #{self.inspect} #{self.year} #{self.month} #{self.day}"
    puts "Year: #{self.year} #{self.month}"
    mdays = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    mdays[2] = 29 if Date.leap?(self.year)
    puts mdays[self.month]
    mdays[self.month]
  end

  def calendar
    days = month_days
    t = Time.mktime(self.year, self.month, 1)
    first = t.wday
    list = *1..days
    weeks = [[]]
    week1 = 7 - first
    week1.times { weeks[0] << list.shift }
    nweeks = list.size/7 + 1
    nweeks.times do |i|
      weeks[i+1] ||= []
      7.times do
        break if list.empty?
        weeks[i+1] << list.shift
      end
    end
    pad_first = 7-weeks[0].size
    pad_first.times { weeks[0].unshift(nil) }
    pad_last = 7-weeks[0].size
    pad_last.times { weeks[-1].unshift(nil) }
    weeks
  end

  def mnth
    (self.quarter - 1) * 3 + self.month
  end

  def create_year_first_year(week)
    mdays = month_days
    week.date_string = week.day.ordinal << Time.local(week.year,week.month,week.day).strftime(" %B")
    week.save
    this_year = week.year

    53.times do |d|
      t = Time.local(week.year, week.month, week.day)+(86400*7)
      break if t.year > this_year
      week.week += 1
      week.week = 1 if t.month > week.month
      week.month = t.month
      week.day = t.day
      dstring = week.day.ordinal << t.strftime(" %B") # Format the date
      Weekdate.create(:year => week.year,
                      :qmw => "#{((week.month-1)/3)+1}#{((week.month-1)%3)+1}#{week.week}",
                      :quarter => "#{((week.month-1)/3)+1}",
                      :month => week.month, :day => week.day, :week => week.week,
                      :date_string => "#{dstring}")
    end
  end
end
