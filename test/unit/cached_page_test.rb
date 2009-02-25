require 'test_helper'

class CachedPageTest < ActiveSupport::TestCase
  def test_fetch
    content = CachedPage.content_for_url("http://google.com")
    assert_kind_of String, content
  end
end
