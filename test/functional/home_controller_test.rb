require File.dirname(__FILE__) + '/../test_helper'

class HomeControllerTest < ActionController::TestCase
  TYPES = :domains, :users, :sprigs, :parselets

  def setup
    HomeController.send :attr_accessor, *TYPES
  end

  def test_routing
    assert_routing "/", :controller => "home", :action => "index"
  end
  
  def test_flash
    get :index, nil, nil, :notice => "hello world"
    assert_select "div#notice", "hello world"
  end
  
  def test_logo
    get :index
    assert_select "#logo", "parselets"
  end
  
  def test_content
    get :index
    TYPES.each do |method|
      assert_not_nil @controller.send(method)
    end
    
    assert_select "h3", TYPES.length
    assert_select "ol", TYPES.length
  end
end