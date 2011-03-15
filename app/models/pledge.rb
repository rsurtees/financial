# == Schema Information
# Schema version: 20110223021550
#
# Table name: pledges
#
#  id         :integer         not null, primary key
#  amount     :float
#  freq       :string(20)
#  amount2    :float
#  freq2      :string(20)
#  pledge_09  :float           default(0.0)
#  pledge_10  :float           default(0.0)
#  pledge_11  :float           default(0.0)
#  pledge_12  :float           default(0.0)
#  pledge_13  :float           default(0.0)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

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

