require_dependency "open-uri"
require "timeout"
class CachedPage < ActiveRecord::Base
  CACHE_TIME = 1.day
  
  module ClassMethods
    def content_for_url(url)
      t = find_or_create_by_url(url)
      t && t.content
    end
  
    def find_or_create_by_url(url)
      url = url.to_s
      page = find_or_initialize_by_url(url)
      # page = new(:url => url) if page.updated_at && (page.updated_at < CACHE_TIME.ago)
      
      begin
        Timeout::timeout(2) {
          raise("Robots.txt disallowed: #{url}") unless ROBOTS.allowed?(url)
          page.content ||= URI.parse(url).open("User-Agent" => Parsley.user_agent).read
        }
      rescue Exception => e
        page.error_message = e.message
        logger.warn "Ignoring http fetch error: #{e.message}"
      end
      
      page.save!
      page
    end
  end
  extend ClassMethods
  
  def updated_at
    self[:updated_at] || created_at
  end
end
