require File.dirname(__FILE__) + "/../../lib/json_zip"
require "test/unit"

class JsonZipTest < Test::Unit::TestCase
  include JsonZip
  
  def setup
    @empty = JsonZip::Object.new({}, {})
    @parselet = OrderedJSON.parse <<-JSON
      {
        "foo": "a",
        "bar(a)": [{
          "baz": ".",
          "link": "@href"
        }]
      }
    JSON
    @data = OrderedJSON.parse <<-JSON
      {
        "foo": "hi world",
        "bar": [
          {
            "baz": "hi world",
            "link": "/hello"
          },
          {
            "baz": "bye world",
            "link": "/bye"
          }
        ]
      }
    JSON
  end
  
  def test_simple_zip
    assert_equal @empty, JsonZip.zip(OrderedHash.new, OrderedHash.new)
  end
  
  def test_empty_zip
    zipped = JsonZip.zip(@parselet, @empty)
    
    assert_equal @parselet.inspect, zipped.inspect
  end
  
  def test_full_zip
    zipped = JsonZip.zip(@parselet, @data)
    assert_kind_of JsonZip::Object, zipped
    assert_equal 2, zipped.length
    assert_equal [String.new("foo", "foo"), String.new("bar(a)", "bar")], zipped.keys
    
    key = zipped.keys.last
    assert_equal "bar", key.base
    assert_equal "(a)", key.filter
    assert_equal "bar(a)", key
    
    str, arr = zipped.values
    assert_kind_of String, str
    assert_kind_of Array, arr
    assert_equal 2, arr.entries.length
    assert_kind_of OrderedHash, arr.entries.first
    
    assert_equal "a", str.selector
    assert_equal "hi world", str.value
    
    obj = arr.first
    assert_kind_of Object, obj
    assert_equal 2, obj.keys.length
    
    assert_equal @parselet.inspect, zipped.inspect
  end
end
