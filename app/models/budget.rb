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
