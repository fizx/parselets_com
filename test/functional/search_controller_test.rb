require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  test "routing works" do
    assert_recognizes({ :controller => 'search', :action => 'index' }, '/search')
  end
end
