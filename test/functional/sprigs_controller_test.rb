require 'test_helper'

class SprigsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sprigs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sprig" do
    assert_difference('Sprig.count') do
      post :create, :sprig => { }
    end

    assert_redirected_to sprig_path(assigns(:sprig))
  end

  test "should show sprig" do
    get :show, :id => sprigs(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => sprigs(:one).id
    assert_response :success
  end

  test "should update sprig" do
    put :update, :id => sprigs(:one).id, :sprig => { }
    assert_redirected_to sprig_path(assigns(:sprig))
  end

  test "should destroy sprig" do
    assert_difference('Sprig.count', -1) do
      delete :destroy, :id => sprigs(:one).id
    end

    assert_redirected_to sprigs_path
  end
end
