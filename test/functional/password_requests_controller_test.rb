require File.dirname(__FILE__) + '/../test_helper'

class PasswordRequestsControllerTest < ActionController::TestCase
  test "should get index" do
    login_as :kyle
    get :index
    assert_response :success
    assert_not_nil assigns(:password_requests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create password_request" do
    assert_difference('PasswordRequest.count') do
      post :create, :password_request => { :email => "quentin@example.com" }
    end

    assert_redirected_to password_request_path(assigns(:password_request))
  end

  test "should show password_request" do
    login_as :kyle
    get :show, :id => password_requests(:one).id
    assert_response :success
  end

  test "should get edit" do
    login_as :kyle
    get :edit, :id => password_requests(:one).id
    assert_response :success
  end

  test "should update password_request" do
    login_as :kyle
    put :update, :id => password_requests(:one).id, :password_request => { }
    assert_redirected_to password_request_path(assigns(:password_request))
  end

  test "should destroy password_request" do
    login_as :kyle
    assert_difference('PasswordRequest.count', -1) do
      delete :destroy, :id => password_requests(:one).id
    end

    assert_redirected_to password_requests_path
  end
end
