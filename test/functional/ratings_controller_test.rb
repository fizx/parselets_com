require 'test_helper'

class RatingsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ratings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rating" do
    assert_difference('Rating.count') do
      post :create, :rating => { }
    end

    assert_redirected_to rating_path(assigns(:rating))
  end

  test "should show rating" do
    get :show, :id => ratings(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => ratings(:one).id
    assert_response :success
  end

  test "should update rating" do
    put :update, :id => ratings(:one).id, :rating => { }
    assert_redirected_to rating_path(assigns(:rating))
  end

  test "should destroy rating" do
    assert_difference('Rating.count', -1) do
      delete :destroy, :id => ratings(:one).id
    end

    assert_redirected_to ratings_path
  end
end
