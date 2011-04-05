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
