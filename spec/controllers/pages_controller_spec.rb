require 'spec_helper'

describe PagesController do

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end
  end

  describe "GET 'currentyear'" do
    it "should be successful" do
      get 'currentyear'
      response.should be_success
    end
  end

  describe "GET 'weekdate'" do
    it "should be successful" do
      get 'weekdate'
      response.should be_success
    end
  end

  describe "GET 'budget'" do
    it "should be successful" do
      get 'budget'
      response.should be_success
    end
  end

  describe "GET 'pledge'" do
    it "should be successful" do
      get 'pledge'
      response.should be_success
    end
  end

  describe "GET 'user'" do
    it "should be successful" do
      get 'user'
      response.should be_success
    end
  end

  describe "GET 'donation'" do
    it "should be successful" do
      get 'donation'
      response.should be_success
    end
  end

end
