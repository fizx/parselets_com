require 'test_helper'

class ParseletsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:parselets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create parselet" do
    assert_difference('Parselet.count') do
      post :create, :parselet => { }
    end

    assert_redirected_to parselet_path(assigns(:parselet))
  end

  test "should show parselet" do
    get :show, :id => parselets(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => parselets(:one).id
    assert_response :success
  end

  test "should update parselet" do
    put :update, :id => parselets(:one).id, :parselet => { }
    assert_redirected_to parselet_path(assigns(:parselet))
  end

  test "should destroy parselet" do
    assert_difference('Parselet.count', -1) do
      delete :destroy, :id => parselets(:one).id
    end

    assert_redirected_to parselets_path
  end
end
