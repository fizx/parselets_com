require File.dirname(__FILE__) + '/../test_helper'

class TopTest < ActiveSupport::TestCase
  KLASSES = [Parselet, User, Domain]
  
  def test_models_define_top
    KLASSES.each do |klass|
      klass.top.each do |o|
        assert_kind_of klass, o
      end
    end
  end
end
