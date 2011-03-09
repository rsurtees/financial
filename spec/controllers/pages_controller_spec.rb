require 'spec_helper'

describe PagesController do

  before(:each) do
    @base_title = "NBC Financial Giving Records"
  end

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
  end

    it "should have the right title" do
		  get 'home'
		  response.should have_selector("title",
                                    :content => "#{@base_title} | Home")
    end
  end

  describe "GET 'currentyear'" do
    it "should be successful" do
      get 'currentyear'
      response.should be_success
    end

    it "should have the right title" do
		  get 'home'
		  response.should have_selector("title",
                                    :content => "#{@base_title} | Current Year")
    end
  end

  describe "GET 'weekdate'" do
    it "should be successful" do
      get 'weekdate'
      response.should be_success
    end

    it "should have the right title" do
		  get 'home'
		  response.should have_selector("title",
                                    :content => "#{@base_title} | Week Dates")
    end
  end

  describe "GET 'budget'" do
    it "should be successful" do
      get 'budget'
      response.should be_success
    end

    it "should have the right title" do
		  get 'home'
		  response.should have_selector("title",
                                    :content => "#{@base_title} | Budget Items")
    end
  end

  describe "GET 'pledge'" do
    it "should be successful" do
      get 'pledge'
      response.should be_success
    end

    it "should have the right title" do
		  get 'home'
		  response.should have_selector("title",
                                    :content => "#{@base_title} | Pledges")
    end
  end

  describe "GET 'user'" do
    it "should be successful" do
      get 'user'
      response.should be_success
    end

    it "should have the right title" do
		  get 'home'
		  response.should have_selector("title",
                                    :content => "#{@base_title} | Users")
    end
  end

  describe "GET 'donation'" do
    it "should be successful" do
      get 'donation'
      response.should be_success
    end

    it "should have the right title" do
		  get 'home'
		  response.should have_selector("title",
                                    :content => "#{@base_title} | Donation Records")
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end

    it "should have the right title" do
		  get 'home'
		  response.should have_selector("title",
                                    :content => "#{@base_title} | About")
    end
  end

end
