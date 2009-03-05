require File.dirname(__FILE__) + '/../test_helper'

class ParseletTest < ActiveSupport::TestCase
  def setup
    super
    @parselet = Parselet.new({
      :pattern => "http://www.yelp.com/",
      :example_url => "http://www.yelp.com/",
      :name => "foo",
      :description => "bar",
      :user => User.find(:first)
    })
  end
  
  def test_signature
    assert_equal "#comment[#comment #comment[#score #comment[#time #comment[#user #comment_count #description #embed #rating #title #uploaded_at #uploader #views", parselets(:youtube).calculate_signature
  end
  
  def test_compress_example_data
    example_data = File.read(File.dirname(__FILE__) + "/../fixtures/example_data.txt")
    Parselet.compress_json(example_data)
  end
  
  def indifferent(object)
    case object
    when Hash
      object.inject({}.with_indifferent_access) do |m, (k, v)|
        m[k] = indifferent(v)
        m
      end
    when Array
      object.map{|e| indifferent(e) }
    else
      object
    end
  end
  
  def test_tmp_from_params_edge_case
    p = indifferent({"commit"=>"Save", "action"=>"code", "_method"=>"put", "authenticity_token"=>"C5eiAKLMMRi+ZWu1xntW66zrIwUU2AooTRBSlGCAPfM=", "root-command"=>"", "controller"=>"parselets", "root"=>{"0"=>{"multi"=>"true", "value"=>{"0"=>{"value"=>".title a", "key"=>"title"}, "1"=>{"value"=>".title a @href", "key"=>"link"}, "2"=>{"value"=>"number(regex:match(., '[0-9]+', ''))", "key"=>"comment_count(.subtext a:nth-child(3))"}, "3"=>{"value"=>".subtext a:nth-child(3) @href", "key"=>"comment_link"}, "4"=>{"key"=>"points"}}, "key"=>"articles"}, "1"=>{"value"=>".title:nth-child(2) a @href", "key"=>"next"}, "2"=>{"key"=>""}}, "parselet"=>{"name"=>"yc", "example_url"=>"http://news.ycombinator.com/", "pattern"=>"http://news.ycombinator.com/{guid?}", "description"=>"hacker news"}, "_"=>"", "editor_helpful"=>"true"})
    expected = "{ \"articles\": [ { \"title\": \".title a\", \"link\": \".title a @href\", \"comment_count(.subtext a:nth-child(3))\": \"number(regex:match(., '[0-9]+', ''))\", \"comment_link\": \".subtext a:nth-child(3) @href\", \"points\": \"\" } ], \"next\": \".title:nth-child(2) a @href\" }"
    assert_equal expected, Parselet.tmp_from_params(p).code
  end
  
  def test_new_parselet_returns_empty_json
    assert_equal "{}", @parselet.code
    assert_equal Hash.new, @parselet.json
  end
  
  def test_creating_slightly_different
    Parselet.new(parselets(:youtube).attributes.merge({:name => "foobar"})).save!
  end
  
  def test_find_by_params
    params = {:id => "youtube-video"}
    assert_not_nil Parselet.find_by_params(params)
    
    params = {:id => "MyString"}

    assert_equal parselets(:one), Parselet.find_by_params(params)
    
    params = {:id => "1"}
    assert_equal parselets(:one), Parselet.find_by_params(params)
    
    params = {:something => "else"}
    assert_nil Parselet.find_by_params(params)
  end
  
  def test_pattern_tokens
    @parselet.pattern = "http://www.yelp.com/{city?}&{foo}&\\{not bar\\}"
    url_chunks, keys = @parselet.pattern_tokens
    assert_equal %w[city? foo], keys
    assert_equal ["http://www.yelp.com/", "&", "&{not bar}"], url_chunks
  end
  
  def test_pattern_validity
    @parselet.pattern = "http://www.yelp.com/{city?}"
    assert @parselet.pattern_valid?
    assert @parselet.pattern_matches?("http://www.yelp.com/foo")
    assert @parselet.pattern_matches?("http://www.yelp.com/")
    assert !@parselet.pattern_matches?("http://www.yahoo.com/")
  end
  
  def test_code_verifies_json
    assert_raises(ActiveRecord::RecordInvalid) do
      @parselet.code = "asfd"
      @parselet.save!
    end
    assert_raises(ActiveRecord::RecordInvalid) do
      @parselet.code = "asfd"
      @parselet.save!
    end
    @parselet.code = "{}"
    @parselet.save!
  end
  
  def test_tmp_from_params_command
    params = {:root => {"0" => {"key" => "title", "value" => "h1"}}}
    params[:"root-command"] = "root,0,multify"
    output = { "title" => ["h1"] }
    assert_tmp_transform(params, output)
    
    params = {:root => {"0" => {"key" => "title", "value" => "h1"}}}
    params[:"root-command"] = "root,0,objectify"
    output = { "title" => {"" => "h1"} }
    assert_tmp_transform(params, output)
    
    params = {:root => {"0" => {"key" => "title", "value" => "h1", "deleted" => "true"}}}
    params[:"root-command"] = "root,0,multify"
    output = { }
    assert_tmp_transform(params, output)
  end
    
  def test_tmp_from_params
    assert Parselet.respond_to?(:tmp_from_params)
    assert_tmp_transform({}, {})
    
    params = {:root => {"0" => {"key" => "title", "value" => "h1"}}}
    output = { "title" => "h1" }
    assert_tmp_transform(params, output)
    
    params = {:root => {"0" => {"multi"=>"true", "key"=>"foo"}}}
    output = {"foo" => [""]}
    assert_tmp_transform(params, output)
    
    params = {:root => {"0" => {"value"=>"!array", "key"=>"foo"}}}
    output = {"foo" => []}
    assert_tmp_transform(params, output)
    
    params = {:root => {"0" => {"value"=>"!hash", "key"=>"foo"}}}
    output = {"foo" => {}}
    assert_tmp_transform(params, output)
    
    params = {:root => {"0" => {"key" => "title", "value" => "h1", "multi" => "true"}}}
    output = { "title" => ["h1"] }
    assert_tmp_transform(params, output)
    
    params = {:root => {"0"=>{"value"=>{"0"=>{"key"=>"bar"}}, "key"=>"foo"}}}
    output = {"foo" => {"bar" => ""}}
    assert_tmp_transform(params, output)
  end
  
  def assert_tmp_transform(input, output)
    parselet = Parselet.tmp_from_params(input)
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
