require "rubygems"
require "ordered_json"
module JsonZip
  def self.zip(a, b)
    case a
    when ::Hash:   Object.new(a, b)
    when ::Array:  Array.new(a, b)
    when ::String: String.new(a, b)
    else ;         raise "wtf"
    end
  end
  
  class Object < OrderedHash
    def initialize(a, b)
      super()
      b ||= {}
      a.keys.zip(b.keys).each do |ka, kb|
        self[String.new(ka, kb)] = JsonZip.zip(a[ka], b[kb])
      end
    end
  end
  
  class Array < ::Array
    attr_reader :entries
    def initialize(a, b)
      super()
      self << JsonZip.zip(a.first, b && b.first)
      @entries = b
    end
  end
  
  class String < ::String
    attr_reader :base, :filter, :selector, :value
    
    def initialize(a, b)
      super(a)
      split = a.split("(")
      @base = split.shift
      join = split.join("(")
      @filter = join && "(#{join}"
      @selector = a
      @value = b
    end
    
  end
end