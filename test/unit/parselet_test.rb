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
  
  def test_pretty_example_url
    @parselet.pattern = "http://www.yelp.com/{city}"
    @parselet.example_url = "http://www.yelp.com/Austin"
    assert_equal "http://www.yelp.com/<b>Austin</b>", @parselet.pretty_example_url
  end
  
  def test_domain_creation
    @parselet.pattern = @parselet.example_url = "http://omg.com/"
    assert @parselet.save
    assert Domain.find_by_name("omg.com")
  end
  
  def test_signature
    assert_equal "/comment//comment /comment//score /comment//time /comment//user /comment_count /description /embed /rating /title /uploaded_at /uploader /views", parselets(:youtube).calculate_signature
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
