# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def icon(name, alt = nil)
    image_tag("/icons/#{name}.png", :border => 0, :align => "absmiddle", :alt => alt, :title => alt)
  end
  
  def empty_icon
    image_tag("/images/spacer.gif", :width => 16, :height => 16, :border => 0, :align => "absmiddle")
  end
  
  def thumb(url)
    image_tag Thumbnail.path_for(url), :class => "thumb", :border => 0
  end
end
