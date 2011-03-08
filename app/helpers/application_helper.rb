module ApplicationHelper

  class InitializeAll
    def create_all
      create_current_years
      create_weekdates
      create_users
      create_budgets
      create_pledges
      create_donations

      Budget.new.fill_db
      User.new.fill_db
      Pledge.new.fill_db
      Donation.new.fill_db
    end
  end

  class InitializeWeeks
    def create_weeks
      create_current_years
      create_weekdates
    end
  end

  class CurrentYearObj
    attr_reader :id, :year, :first_week
    attr_writer :id, :year, :first_week

    def initialize()
      @id = @year = @first_week = nil
      @created = Date.today
    end

    def to_s()
      "#{@id}\t#{@year}\t#{@first_week}\t#{@created}"
    end
  end


end
