require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  def test_escape_and_highlight
    string = "this is #{START_PARSELET_HIGHLIGHT}high<a>lighted#{END_PARSELET_HIGHLIGHT} and this is not, but #{START_PARSELET_HIGHLIGHT}this is#{END_PARSELET_HIGHLIGHT}!"
    
    assert(escape_and_highlight(string).include?('&lt;') && escape_and_highlight(string).include?('&gt;'))
    assert !(string.include?('&lt;') && string.include?('&gt;'))

    # Array(0...70).each do |i|
    #   puts i.to_s + ' -> ' + escape_and_highlight(string, :truncate => i).gsub(/<\/?strong>/, '')
    # end
  end
end
