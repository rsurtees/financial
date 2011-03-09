class PagesController < ApplicationController
  def home
	@title = "Home"
  end

  def currentyear
	@title = "Current Year"
  end

  def weekdate
	@title = "Week Dates"
  end

  def budget
	@title = "Budget Items"
  end

  def pledge
	@title = "Pledges"
  end

  def user
	@title = "Users"
  end

  def donation
	@title = "Donation Records"
  end

  def about
	@title = "About"
  end

end
