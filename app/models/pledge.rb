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

class Pledge < ActiveRecord::Base
  belongs_to :user

  def total_pledge
    @total_pledge = self.amount*52.0*3.0 if self.freq == "Week"
    @total_pledge = self.amount*12.0*3.0 if self.freq == "Month"
    @total_pledge = self.amount*4.0*3.0 if self.freq == "Quarter"
    @total_pledge = self.amount*3.0 if self.freq == "Year"
    @total_pledge = self.amount if self.freq == "Total"
    @total_pledge += self.amount2*52.0*3.0 if self.freq2 == "Week"
    @total_pledge += self.amount2*12.0*3.0 if self.freq2 == "Month"
    @total_pledge += self.amount2*4.0*3.0 if self.freq2 == "Quarter"
    @total_pledge += self.amount2*3.0 if self.freq2 == "Year"
    @total_pledge += self.amount2 if self.freq2 == "Total"
    puts "Total pledges is #{@total_pledge} and Amount is #{self.amount}"
    return @total_pledge
  end

  def update_pledges
	data_file = File.open("./doc/2009.tab")
	data_records = data_file.readlines("\n")
	data_records.shift

	data_file10 = File.open("./doc/2010.tab")
	data_records10 = data_file10.readlines("\n")
	data_records10.shift

	@hash_amounts = Hash.new
	data_records.each do |r|
	  rec = Array.new r.chomp.split("\t")
	  next unless rec[5].to_i==6
	  rec = rec.values_at(1,6)
	  rec[0]=rec[0].to_i
	  rec[1]=rec[1].to_f
	  if @hash_amounts.key?(rec[0]) then
		tmp = @hash_amounts.fetch(rec[0])
		tmp[0] += rec[1]
		@hash_amounts.store(rec[0], tmp)
	  else
		tmp = Array[rec[1], 0.0]
		@hash_amounts.store(rec[0], tmp)
	  end
	end

	@hash_amounts.sort.each do |r|
	  puts "#{r[0]}\t#{r[1][0]}\t#{r[1][1]}"
	end  

	data_records10.each do |r|
	  rec = Array.new r.chomp.split("\t")
	  next unless rec[5].to_i==6
	  rec = rec.values_at(1,6)
	  rec[0]=rec[0].to_i
	  rec[1]=rec[1].to_f
	  if @hash_amounts.key?(rec[0]) then
		tmp = @hash_amounts.fetch(rec[0])
		tmp[1] += rec[1]
		@hash_amounts.store(rec[0], tmp)
	  else
		tmp = Array[0.0, rec[1]]
		@hash_amounts.store(rec[0], tmp)
	  end
	end

	pledges = Pledge.find(:all)
	pledges.each do |u|
	  if (@hash_amounts.key?(u.user_id)) then
		pledge = @hash_amounts.fetch(u.user_id)
		puts pledge.inspect
		u.pledge_09 = pledge[0]
		u.pledge_10 = pledge[1]
		puts u.inspect
		u.save
	  else
		puts "#{u.id} not found"
	  end
	end
  end

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

