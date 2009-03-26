# Allow the metal piece to run in isolation
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)
require "facets/lrucache"

class CacheableTime < Time
  include LRUCache::Item
end

class ApiLimit
  KEY_REGEX = /api_key=([\w\-]+)/
  MAX_CACHE_ITEMS = 100
  TIME_BETWEEN_REQUESTS = 2.0
  
  HOLD = [503, {"Content-Type" => "text/html"}, ["Please be patient and observe the #{1.0/TIME_BETWEEN_REQUESTS} request per second limit."]]
  PASS = [404, {"Content-Type" => "text/html"}, ["Not Found"]]
  
  CACHE = LRUCache.new(MAX_CACHE_ITEMS)
  
  def self.call(env)
    if env["PATH_INFO"] =~ KEY_REGEX
      key = $1
      if(CACHE[key] && Time.now - CACHE[key] < TIME_BETWEEN_REQUESTS)
        return HOLD
      else
        CACHE[key] = CacheableTime.now
      end
    end
    return PASS
  end
end
