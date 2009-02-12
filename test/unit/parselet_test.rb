require File.dirname(__FILE__) + '/../test_helper'

class ParseletTest < ActiveSupport::TestCase
  def setup
    @parselet = Parselet.new
  end
  
  def test_new_parselet_returns_empty_json
    assert_equal "{}", @parselet.code
    assert_equal Hash.new, @parselet.json
  end
  
  def test_tmp_from_params_command
    command = "root,0,multify"
    params = {"0" => {"key" => "title", "value" => "h1"}}
    output = { "title" => ["h1"] }
    assert_tmp_transform(params, output, command)
    
    command = "root,0,objectify"
    params = {"0" => {"key" => "title", "value" => "h1"}}
    output = { "title" => {"" => "h1"} }
    assert_tmp_transform(params, output, command)
  end
    
  def test_tmp_from_params
    assert Parselet.respond_to?(:tmp_from_params)
    assert_tmp_transform({}, {})
    
    params = {"0" => {"key" => "title", "value" => "h1"}}
    output = { "title" => "h1" }
    assert_tmp_transform(params, output)
    
    params = {"0" => {"multi"=>"true", "key"=>"foo"}}
    output = {"foo" => []}
    assert_tmp_transform(params, output)
    
    params = {"0" => {"value"=>"!array", "key"=>"foo"}}
    output = {"foo" => []}
    assert_tmp_transform(params, output)
    
    params = {"0" => {"value"=>"!hash", "key"=>"foo"}}
    output = {"foo" => {}}
    assert_tmp_transform(params, output)
    
    params = {"0" => {"key" => "title", "value" => "h1", "multi" => "true"}}
    output = { "title" => ["h1"] }
    assert_tmp_transform(params, output)
    
    params = {"0"=>{"value"=>{"0"=>{"key"=>"bar"}}, "key"=>"foo"}}
    output = {"foo" => {"bar" => nil}}
    assert_tmp_transform(params, output)
  end
  
  def assert_tmp_transform(input, output, command = nil)
    parselet = Parselet.tmp_from_params(input, command)
    assert_kind_of Parselet, parselet
    assert_equal output, parselet.json
  end
  
  def test_jsonization
    code = %[{ "foo": "bar" }]
    @parselet.code = code
    assert_equal code, @parselet.code
    assert_equal OrderedJSON.parse(code), @parselet.json
    
    @parselet.json = OrderedJSON.parse(code)
    assert_equal code, @parselet.code
  end
end
