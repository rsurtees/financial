# == Schema Information
# Schema version: 20110223021550
#
# Table name: users
#
#  id         :integer         not null, primary key
#  first      :string(50)
#  surname    :string(50)
#  street     :string(50)
#  po_box     :string(50)
#  town       :string(50)
#  state      :string(50)
#  zip        :string(5)
#  email      :string(50)
#  status     :boolean
#  pledge_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  has_many :donations
  has_one :pledge, :dependent => :destroy

  def select_list
	all_users = User.find(:all, :order => [:surname, :first])
	user_array = Array[["User Name", nil]]
	all_users.each do |u|
	  user_array.push Array[u.surname + ", " + u.first, u.id ]
	end
	return user_array
  end

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
