require 'test_helper'

class CurrentYearsControllerTest < ActionController::TestCase
  setup do
    @current_year = current_years(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:current_years)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create current_year" do
    assert_difference('CurrentYear.count') do
      post :create, :current_year => @current_year.attributes
    end

    assert_redirected_to current_year_path(assigns(:current_year))
  end

  test "should show current_year" do
    get :show, :id => @current_year.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @current_year.to_param
    assert_response :success
  end

  test "should update current_year" do
    put :update, :id => @current_year.to_param, :current_year => @current_year.attributes
    assert_redirected_to current_year_path(assigns(:current_year))
  end

  test "should destroy current_year" do
    assert_difference('CurrentYear.count', -1) do
      delete :destroy, :id => @current_year.to_param
    end

    assert_redirected_to current_years_path
  end
end
