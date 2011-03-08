require 'rubygems'
#require 'mysql_api'
#require 'mysql'
require 'active_record'
require 'active_record/railtie'
require 'logger'

LASTYEAR = 2010
FIRSTSUNDAY = 3

class Numeric
  def ordinal
    self.to_s + ((10...20).include?(self) ? 'th' : %w{ th st nd rd th th th th th th }[self % 10])
  end
end

class BudgetObj
  attr_reader :id, :description, :created

  def initialize()
    @id = @description = nil
    @created = Date.today
  end

  def create(aLine)
    @id = aLine.shift.to_i
    @description = aLine.shift
  end

  def to_s()
    "#{@id}\t#{@description}\t#{@created.strftime('%m/%d/%Y')}"
  end

end

class PledgeObj
  attr_reader :id, :user_id, :amount, :freq, :amount2, :freq2, :created, :total_pledge

  def initialize()
    @id = @user_id = @amount = @freq = @amount2 = @freq2 = nil
    @total_pledge = @pledge_09 = @pledge_10 = @pledge_11 = @pledge_12 = @pledge_13 = 0.0
    @created = Date.today
  end

  def create(aLine)
    @id = aLine.shift.to_i
    @user_id = aLine.shift.to_i
    aLine.shift
    @amount = aLine.shift.to_f
    @freq = aLine.shift
    @amount2 = aLine.shift.to_f
    @freq2 = aLine.shift
    @total_pledge = @amount*52.0*3.0 if @freq == "Week"
    @total_pledge = @amount*12.0*3.0 if @freq == "Month"
    @total_pledge = @amount*4.0*3.0 if @freq == "Quarter"
    @total_pledge = @amount*3.0 if @freq == "Year"
    @total_pledge = @amount if @freq == "Total"
    @total_pledge += @amount*52.0*3.0 if @freq == "Week"
    @total_pledge += @amount*12.0*3.0 if @freq == "Month"
    @total_pledge += @amount*4.0*3.0 if @freq == "Quarter"
    @total_pledge += @amount*3.0 if @freq == "Year"
    @total_pledge += @amount if @freq == "Total"
  end

  def to_s()
    "#{@id}\t#{@user_id}\t#{@amount}\t#{@freq}\t#{@amount2}\t#{@freq2}\t#{@total_pledge}\t#{@created}"
  end
end

class UserObj
  attr_reader :id, :name, :first, :surname, :street, :po_box, :town, :state, :zip, :created, :amount, :freq, :email, :status, :pledge_id
  attr_writer :status, :pledge_id

  def initialize()
    @id = @name = @first = @last = @street = @po_box = @city = @state = @zip = @amount = @freq = @email = @status = @pledge_id = nil
    @created = Date.today
  end

  def create(aLine)
    @id = aLine.shift.to_i
    aLine.shift
    @status = aLine.shift
    @first = aLine.shift
    @surname = aLine.shift
    @street = aLine.shift
    @town = aLine.shift
    @state = aLine.shift
    @zip = aLine.shift
    @amount = aLine.shift
    @freq = aLine.shift
    @po_box = aLine.shift
    aLine.shift
    aLine.shift
    @email = aLine.shift
  end

  def to_s()
    "#{@id}\t#{@first}\t#{@surname}\t#{@street}\t#{@po_box}\t#{@town}\t#{@state}\t#{@zip}\t#{@created}\t#{@amount}\t#{@freq}\t#{@email}\t#{@status}"
  end
end

class DonationObj
  attr_reader :id, :user_id, :week, :month, :quarter, :budget_id, :amount, :qmw, :created

  def initialize()
    @id = @user_id = @week = @month = @quarter = @budget_id = @amount = @qmw = nil
    @created = Date.today
  end

  def create(aLine)
    @id = aLine.shift.to_i
    @user_id = aLine.shift.to_i
    @quarter = aLine.shift.to_i
    @month = aLine.shift.to_i
    @week = aLine.shift.to_i
    @budget_id = aLine.shift.to_i
    @amount = aLine.shift.to_f
    @qmw = @quarter * 100 + @month * 10 + @week
    @created = aLine.shift
  end

  def to_s()
    "#{@id}\t#{@user_id}\t#{@quarter}\t#{@month}\t#{@week}\t#{@budget_id}\t#{@amount}\t#{@qmw}\t #{@created}"
  end
end

class Budget < ActiveRecord::Base
  has_many :donations

  def fill_db
    data_file = File.open("/Users/Shared/NBC2010/Budget.tmp")
    data_records = data_file.readlines("\r")
    data_records.each do |r|
      obj = BudgetObj.new
      rec = r.chomp.split("\t")
      obj.create(rec)
      rec = Budget.new do |u|
        u.id = obj.id
        u.description = obj.description
      end
      rec.save
    end
    nil
  end
end

class CreateBudgets < ActiveRecord::Migration
  def self.up
    create_table :budgets do |t|
      t.string :description, :limit => 50

      t.timestamps
    end
  end

  def self.down
    drop_table :budgets
  end
end

class Pledge < ActiveRecord::Base
  belongs_to :user

  def fill_db
    data_file = File.open("/Users/Shared/NBC2010/Pledge.tmp")
    data_records = data_file.readlines("\r")
    usr = nil
    data_records.each do |r|
    #puts r
      obj = PledgeObj.new
      rec = r.chomp.split("\t")
      obj.create(rec)
      rec = Pledge.new do |p|
        p.id = obj.id
        p.user_id = obj.user_id
        p.amount = obj.amount
        p.freq = obj.freq
        p.amount2 = obj.amount2
        p.freq2 = obj.freq2
        usr = User.find(:first, :conditions => {:id => obj.user_id})
        puts usr.inspect, obj.inspect
        usr.pledge_id = obj.id
      end
      usr.save
      rec.save
    end
    nil
  end
end


class CreatePledges < ActiveRecord::Migration
  def self.up
    create_table :pledges do |t|
      t.integer :user_id
      t.float :amount, :precision => 10, :scale => 2
      t.string :freq, :limit => 20
      t.float :amount2, :precision => 10, :scale => 2
      t.string :freq2, :limit => 20
      t.float :pledge_09, :precision => 10, :scale => 2, :default => 0.0
      t.float :pledge_10, :precision => 10, :scale => 2, :default => 0.0
      t.float :pledge_11, :precision => 10, :scale => 2, :default => 0.0
      t.float :pledge_12, :precision => 10, :scale => 2, :default => 0.0
      t.float :pledge_13, :precision => 10, :scale => 2, :default => 0.0

      t.timestamps
    end
  end

  def self.down
    drop_table :pledges
  end
end

class User < ActiveRecord::Base
  has_many :donations
  has_one :pledge, :dependent => :destroy

  def fill_db
    data_file = File.open("/Users/Shared/NBC2010/NameAddress.tmp")
    data_records = data_file.readlines("\r")
    data_records.each do |r|
    #puts r
      obj = UserObj.new
      rec = r.chomp.split("\t")
      obj.create(rec)
      rec = User.new do |u|
        #puts "#{obj.id} - #{obj.amount}" if obj.amount.to_i > 0
        #puts obj.inspect
        u.id = obj.id
        u.status = true #obj.status
        u.first = obj.first
        u.surname = obj.surname
        u.street = obj.street
        u.po_box = obj.po_box
        u.town = obj.town
        u.state = obj.state
        u.zip = obj.zip
        u.email = obj.email
        u.status = false
        u.pledge_id = nil
      end
      rec.save
    end
    nil
  end
end

class CreateUsers < ActiveRecord::Migration

  def self.up
    create_table :users do |t|
      t.string :first, :limit => 50
      t.string :surname, :limit => 50
      t.string :street, :limit => 50
      t.string :po_box, :limit => 50
      t.string :town, :limit => 50
      t.string :state, :limit => 2
      t.string :zip, :limit => 5
      t.string :email, :limit => 50
      t.boolean :status
      t.integer :pledge_id
      t.boolean :status

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end

class Donation < ActiveRecord::Base
  belongs_to :user
  belongs_to :budget
  belongs_to :weekdate

  def fill_db
    wd = Weekdate.new
    usr = User.new
    bd = Budget.new
    data_file = File.open("/Users/Shared/NBC2010/Financial.tmp")
    data_records = data_file.readlines("\r")
    data_records.each do |r|
      obj = DonationObj.new
      rec = r.chomp.split("\t")
      obj.create(rec)
      wdt = Weekdate.find(:first, :conditions => {:qmw => obj.qmw})
      puts rec.inspect if wdt == nil
      puts obj.inspect if wdt == nil
      puts wdt.inspect if wdt == nil
      usr = User.find(:first, :conditions => {:id => obj.user_id})
      bd = Budget.find(:first, :conditions => {:id => obj.budget_id})
      rec = Donation.new do |u|
        u.id = obj.id
        u.weekdate_id = wdt.id
        u.budget_id = bd.id
        u.user_id = usr.id
        u.amount = obj.amount.to_f
        #puts u.inspect
      end
      rec.save
    end
    nil
  end
end

class CreateDonations < ActiveRecord::Migration
  def self.up
    create_table :donations do |t|
      t.float :amount, :precision => 10, :scale => 2
      t.integer :user_id
      t.integer :weekdate_id
      t.integer :budget_id

      t.timestamps
    end
  end

  def self.down
    drop_table :donations
  end
end

class Weekdate < ActiveRecord::Base
  has_many :donations

  def first
    Weekdate.find :first
  end

  def create_year
    mdays = month_days
    start = first
    #       start.date_string = start.day.ordinal << Time.local(start.year,start.month,start.day).strftime(" %B")
    start.date_string = start.day.ordinal << Time.local(LASTYEAR, start.month, start.day).strftime(" %B")
    start.save
    this_year = start.year

    53.times do |d|
      t = Time.local(start.year, start.month, start.day)+(86400*7)
      break if t.year > this_year
      start.week += 1
      start.week = 1 if t.month > start.month
      start.month = t.month
      start.day = t.day
      dstring = start.day.ordinal << t.strftime(" %B") # Format the date
      Weekdate.create(:qmw => "#{((start.month-1)/3)+1}#{((start.month-1)%3)+1}#{start.week}",
                      :quarter => "#{((start.month-1)/3)+1}",
                      :month => start.month, :day => start.day, :week => start.week,
                      :date_string => "#{dstring}")
    end
  end

  #
  # Determine the number of days in each month
  # Returns an arrary with Jan = [1] with the days in the month
  #
  def month_days
    mdays = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    mdays[2] = 29 if Date.leap?(self.year)
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

end

class CreateWeekdates < ActiveRecord::Migration
  def self.up
    create_table :weekdates, :force => true do |t|
      t.integer :qmw, :limit => 3, :default => 111
      t.integer :year, :limit => 5, :default => LASTYEAR
      t.integer :quarter, :limit => 2, :default => 1
      t.integer :month, :limit => 2, :default => 1
      t.integer :day, :limit => 2, :default => FIRSTSUNDAY
      t.integer :week, :limit => 2, :default => 1
      t.string :date_string, :limit => 20

      t.timestamps
    end

    Weekdate.create
    Weekdate.new.create_year

  end

  def self.down
    drop_table :weekdates
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



class CurrentYear < ActiveRecord::Base
  attr_reader :year, :first_week
  attr_writer :id, :year, :first_week

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

def create_current_years
  ActiveRecord::Schema.define(:version => 2011) do

    create_table "current_years", :force => true do |t|
      t.integer :year, :limit => 4, :default => LASTYEAR
      t.integer :first_week, :limit => 1, :default => FIRSTSUNDAY
      t.datetime :created_at
      t.datetime :updated_at
    end
    CurrentYear.new.fill_db
  end
end

def create_weekdates
  ActiveRecord::Schema.define(:version => 2011) do

    create_table "weekdates", :force => true do |t|
      t.integer :qmw, :limit => 3, :default => 111
      t.integer :year, :limit => 5, :default => LASTYEAR
      t.integer :quarter, :limit => 2, :default => 1
      t.integer :month, :limit => 2, :default => 1
      t.integer :day, :limit => 2, :default => FIRSTSUNDAY
      t.integer :week, :limit => 2, :default => 1
      t.string :date_string, :limit => 20
      t.datetime :created_at
      t.datetime :updated_at
    end
    Weekdate.create
    Weekdate.first.create_year
  end
end

def create_budgets
  ActiveRecord::Schema.define(:version => 2011) do

    create_table "budgets", :force => true do |t|
      t.string :description, :limit => 50
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end

def create_donations
  ActiveRecord::Schema.define(:version => 2011) do

    create_table "donations", :force => true do |t|
      t.float :amount, :precision => 2
      t.integer :user_id
      t.integer :weekdate_id
      t.integer :budget_id
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end

def create_pledges
  ActiveRecord::Schema.define(:version => 2011) do

    create_table "pledges", :force => true do |t|
      t.float :amount, :precision => 2
      t.string :freq, :limit => 20
      t.float :amount2, :precision => 2
      t.string :freq2, :limit => 20
      t.float :pledge_09, :precision => 10, :scale => 2, :default => 0.0
      t.float :pledge_10, :precision => 10, :scale => 2, :default => 0.0
      t.float :pledge_11, :precision => 10, :scale => 2, :default => 0.0
      t.float :pledge_12, :precision => 10, :scale => 2, :default => 0.0
      t.float :pledge_13, :precision => 10, :scale => 2, :default => 0.0
      t.integer :user_id
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end

def create_users
  ActiveRecord::Schema.define(:version => 2011) do

    create_table "users", :force => true do |t|
      t.string :first, :limit => 50
      t.string :surname, :limit => 50
      t.string :street, :limit => 50
      t.string :po_box, :limit => 50
      t.string :town, :limit => 50
      t.string :state, :limit => 50
      t.string :zip, :limit => 5
      t.string :email, :limit => 50
      t.boolean :status
      t.integer :pledge_id
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end

def create_all
  create_current_years
  create_weekdates
  create_users
  create_budgets
  create_pledges
  create_donations
  Budget.new.fill_db
  User.new.fill_db
  Pledge.new.fill_db
  Donation.new.fill_db
end

def create_weeks
  create_current_years
  create_weekdates
end

@log = Logger.new('ActiveRecord.log')
@log.level = level = Logger::DEBUG
@log.datetime_format = "%Y-%m-%d %H:%M:%S"


#ActiveRecord::Base.establish_connection(
#        :adapter => "mysql",
#        :database => "financial2010",
#        :username => "root",
#        :host => "localhost"
#)

ActiveRecord::Base.establish_connection(
    :adapter => "sqlite3",
    :database => "../NBCdata_file.sql3"
)


create_all
