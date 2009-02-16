require File.dirname(__FILE__) + '/../test_helper'

class DomainTest < ActiveSupport::TestCase
  def setup
    @domain = Domain.new
  end
  
  def test_variations
    @domain.name = "yahoo.com"
    @domain.save!
    
    assert_equal " www yahoo www.yahoo com www.com yahoo.com www.yahoo.com", @domain.variations
  end
end
