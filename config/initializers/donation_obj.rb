class DonationObj
  attr_reader :id, :user_id, :week, :month, :quarter, :budget_id, :amount, :qmw, :created

  def initialize()
    @id = @user_id = @week = @month = @quarter = @budget_id = @amount = @qmw = nil
    @created = Date.today
    self
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

