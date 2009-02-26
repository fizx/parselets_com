require 'test_helper'

class PasswordRequestsControllerTest < ActionController::TestCase
  test "should get index" do
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
      post :create, :password_request => { }
    end

    assert_redirected_to password_request_path(assigns(:password_request))
  end

  test "should show password_request" do
    get :show, :id => password_requests(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => password_requests(:one).id
    assert_response :success
  end

  test "should update password_request" do
    put :update, :id => password_requests(:one).id, :password_request => { }
    assert_redirected_to password_request_path(assigns(:password_request))
  end

  test "should destroy password_request" do
    assert_difference('PasswordRequest.count', -1) do
      delete :destroy, :id => password_requests(:one).id
    end

    assert_redirected_to password_requests_path
  end
end
