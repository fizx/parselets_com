require_dependency "open-uri"
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
      page = new(:url => url) if page.updated_at && (page.updated_at < CACHE_TIME.ago)
      page.content ||= URI.parse(url).open("User-Agent" => "Parselets.org").read
      page.save!
      page
    end
  end
  extend ClassMethods
  
  def updated_at
    self[:updated_at] || created_at
  end
end
