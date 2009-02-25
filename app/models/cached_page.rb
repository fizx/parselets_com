require_dependency "open-uri"
class CachedPage < ActiveRecord::Base
  module ClassMethods
    def content_for_url(url)
      puts url.inspect
      t = find_or_create_by_url(url)
      puts t.inspect
      t && t.content
    end
  
    def find_or_create_by_url(url)
      url = url.to_s
      page = find_or_initialize_by_url(url)
      page.content ||= URI.parse(url).open("User-Agent" => "Parselets.org").read
      page.save!
      page
    end
  end
  extend ClassMethods
  
private 
  def fetch(uri_str, limit = 10)
      # You should choose better exception.
      raise ArgumentError, 'HTTP redirect too deep' if limit == 0

      response = Net::HTTP.get_response(URI.parse(uri_str))
      case response
      when Net::HTTPSuccess     then response
      when Net::HTTPRedirection then fetch(response['location'], limit - 1)
      else
        response.error!
      end
    end
end
