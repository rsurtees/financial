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
