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
