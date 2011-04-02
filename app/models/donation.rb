# == Schema Information
# Schema version: 20110223021550
#
# Table name: donations
#
#  id          :integer         not null, primary key
#  amount      :float
#  user_id     :integer
#  weekdate_id :integer
#  budget_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Donation < ActiveRecord::Base
	belongs_to :user
	belongs_to :budget
	belongs_to :weekdate

  validates_numericality_of :amount, :greater_than => 0.0,
      :message => "should be greater that 0.0"
	
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
