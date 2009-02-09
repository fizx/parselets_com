require File.dirname(__FILE__) + '/../test_helper'

class HomeControllerTest < ActionController::TestCase

  def setup
    HomeController.send :attr_accessor, :domains, :users, :sprigs, :parselets
  end

  def test_routing
    assert_routing "/", :controller => "home", :action => "index"
    
  end
  
  def test_content
    get :index
    assert_not_nil @controller.domains
    assert_not_nil @controller.users
    assert_not_nil @controller.sprigs
    assert_not_nil @controller.parselets
  end
end
