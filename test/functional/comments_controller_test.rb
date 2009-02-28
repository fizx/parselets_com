require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:comments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create comments" do
    assert_difference('Comments.count') do
      post :create, :comments => { }
    end

    assert_redirected_to comments_path(assigns(:comments))
  end

  test "should show comments" do
    get :show, :id => comments(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => comments(:one).id
    assert_response :success
  end

  test "should update comments" do
    put :update, :id => comments(:one).id, :comments => { }
    assert_redirected_to comments_path(assigns(:comments))
  end

  test "should destroy comments" do
    assert_difference('Comments.count', -1) do
      delete :destroy, :id => comments(:one).id
    end

    assert_redirected_to comments_path
  end
end
