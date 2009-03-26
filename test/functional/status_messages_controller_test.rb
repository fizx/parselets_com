require 'test_helper'

class StatusMessagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:status_messages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create status_message" do
    assert_difference('StatusMessage.count') do
      post :create, :status_message => { }
    end

    assert_redirected_to status_message_path(assigns(:status_message))
  end

  test "should show status_message" do
    get :show, :id => status_messages(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => status_messages(:one).to_param
    assert_response :success
  end

  test "should update status_message" do
    put :update, :id => status_messages(:one).to_param, :status_message => { }
    assert_redirected_to status_message_path(assigns(:status_message))
  end

  test "should destroy status_message" do
    assert_difference('StatusMessage.count', -1) do
      delete :destroy, :id => status_messages(:one).to_param
    end

    assert_redirected_to status_messages_path
  end
end
