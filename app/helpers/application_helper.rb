require 'digest/md5'
require "cgi"
require "ostruct"

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def icon(name, alt = nil)
    image_tag("/images/icons/#{name}.png", :border => 0, :align => "absmiddle", :alt => alt, :title => alt)
  end
  
  def ratings(parselet)
    render "/widgets/rating", :parselet => parselet
  end
  
  def empty_icon
    image_tag("/images/spacer.gif", :width => 16, :height => 16, :border => 0, :align => "absmiddle")
  end
  
  def example_link(parselet)
    link_to h(parselet.pattern), parselet.example_url, :class => "url", :target => '_blank'
    # , :onmouseover => "this.innerText='#{h truncate(parselet.example_url, :length => 120)}'", 
    #       :onmouseout => "this.innerText='#{h parselet.pattern}'"
  end
  
  def gravatar(email, options = {})
    image_tag gravatar_url_for(email, options), {:class => "thumb", :border => 0}.merge(options)
  end
  
  def mini_gravatar(email)
    gravatar(email, :class => "icon", :s => "16", :align => "absmiddle")
  end

  def gravatar_url_for(email, options = {})
    "http://www.gravatar.com/avatar.php?s=#{options[:s] || 50}&d=#{CGI::escape("http://parselets.com/images/spacer.gif")}&gravatar_id=#{Digest::MD5.hexdigest(email)}"
  end
  
  def syntax_highlight(brush = 'ruby', options = {}, &block)
    out = <<-STR
      <div class='code'>
        <pre class="brush: #{brush}; light: true#{"; #{options[:options]}" if options[:options]}">#{options[:content] || capture(&block)}</pre>
      </div>
    STR
    puts "hi"
    options[:content].nil? ? concat(out) : out
  end
    
  def thumb(object, link = nil)
    is_model = object.is_a?(ActiveRecord::Base)
    url = object.respond_to?(:url) ? object.url : object.to_s
    img = image_tag Thumbnail.path_for(url), :class => "thumb", :border => 0, :align => "absmiddle"
    link ||= object if is_model
    link ? link_to(img, link) : img
  end
  
  def comments(model, small = false)
    link_to icon("balloons") + (small ? "<span class=count id='comments_#{dom_id(model)}'> #{model.comments_count}</span>" : " comments (#{model.comments_count})"), {:controller => "comments", :id => model.id, :type => model.class}, :class => "comments_link", :rel => "facebox"
  end
  
  def status(parselet, small = false)
    ext = small ? "_small" : ""
    case parselet.status
    when "ok"
      icon("tick#{ext}", "This parselet appears to work correctly.")
    when "stale"
      icon("exclamation#{ext}", "This parselet has not been checked recently.")
    when "broken"
      icon("slash#{ext}", "This parselet appears to be broken.")
    when "unknown"
      icon("question#{ext}", "This parselet has unknown status.")
    end
  end
end
