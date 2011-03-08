require 'test_helper'

class WeekdatesControllerTest < ActionController::TestCase
  setup do
    @weekdate = weekdates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:weekdates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create weekdate" do
    assert_difference('Weekdate.count') do
      post :create, :weekdate => @weekdate.attributes
    end

    assert_redirected_to weekdate_path(assigns(:weekdate))
  end

  test "should show weekdate" do
    get :show, :id => @weekdate.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @weekdate.to_param
    assert_response :success
  end

  test "should update weekdate" do
    put :update, :id => @weekdate.to_param, :weekdate => @weekdate.attributes
    assert_redirected_to weekdate_path(assigns(:weekdate))
  end

  test "should destroy weekdate" do
    assert_difference('Weekdate.count', -1) do
      delete :destroy, :id => @weekdate.to_param
    end

    assert_redirected_to weekdates_path
  end
end
