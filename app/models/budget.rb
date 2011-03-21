# == Schema Information
# Schema version: 20110223021550
#
# Table name: budgets
#
#  id          :integer         not null, primary key
#  description :string(50)
#  created_at  :datetime
#  updated_at  :datetime
#

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

class Budget < ActiveRecord::Base
  has_many :donations

  def select_list
	all_budgets = Budget.find(:all, :order => [:description])
	budget_array = Array[["Budget Items", nil]]
	all_budgets.each do |b|
	  budget_array.push Array[b.description, b.id ]
	end
	return budget_array
  end

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
