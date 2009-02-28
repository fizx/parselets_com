require 'digest/md5'
require "cgi"
require "ostruct"

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def icon(name, alt = nil)
    image_tag("/images/icons/#{name}.png", :border => 0, :align => "absmiddle", :alt => alt, :title => alt)
  end
  
  def empty_icon
    image_tag("/images/spacer.gif", :width => 16, :height => 16, :border => 0, :align => "absmiddle")
  end
  
  def gravatar(email, options = {})
    image_tag gravatar_url_for(email, options), :class => "thumb", :border => 0
  end

  def gravatar_url_for(email, options = {})
    "http://www.gravatar.com/avatar.php?gravatar_id=#{Digest::MD5.hexdigest(email)}"
  end
  
  def thumb(object)
    url = object.respond_to?(:url) ? object.url : object.to_s
    image_tag Thumbnail.path_for(url), :class => "thumb", :border => 0
  end
end
