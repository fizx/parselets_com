require 'test_helper'

class KarmaControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:karma)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create karma" do
    assert_difference('Karma.count') do
      post :create, :karma => { }
    end

    assert_redirected_to karma_path(assigns(:karma))
  end

  test "should show karma" do
    get :show, :id => karma(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => karma(:one).to_param
    assert_response :success
  end

  test "should update karma" do
    put :update, :id => karma(:one).to_param, :karma => { }
    assert_redirected_to karma_path(assigns(:karma))
  end

  test "should destroy karma" do
    assert_difference('Karma.count', -1) do
      delete :destroy, :id => karma(:one).to_param
    end

    assert_redirected_to karma_path
  end
end
