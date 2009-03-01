require 'test_helper'

class ThumbnailTest < ActiveSupport::TestCase
  def test_thumb_downloads
    t = Thumbnail.new :url => "http://yahoo.com"
    t.save
    assert File.exists? File.join(RAILS_ROOT, "public", t.path)
  end
  
  def test_path_for
    assert_equal "/thumbs/87/3c/87.jpg", Thumbnail.path_for("http://yahoo.com")
  end
end
