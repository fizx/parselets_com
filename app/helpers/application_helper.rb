require 'digest/md5'
require "cgi"
require "ostruct"

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def icon(name, alt = nil, directory = 'icons')
    extension = (name =~ /\.\w{3,4}$/) ? '' : '.png'
    image_tag("/images/#{directory.length > 0 ? "#{directory}/" : ''}#{name}#{extension}", :border => 0, :align => "absmiddle", :alt => alt, :title => alt)
  end
  
  def wikify(text)
    text.gsub(/\[\[([\w\-]+)\]\]/, '<a href="/parselets/\1">\1</a>')
  end
  
  def parselet_edit_path(parselet)
    "/parselets/#{parselet.name}/#{parselet.version}/edit"
  end

  def parselet_show_path(parselet)
    "/parselets/#{parselet.name}/#{parselet.version}"
  end

  def parselet_usage_path(parselet)
    "/dev/ruby?parselet=#{parselet.name}&version=#{parselet.version}"
  end
  
  def ratings(parselet)
    render "/widgets/rating", :parselet => parselet
  end
  
  def empty_icon
    image_tag("/images/spacer.gif", :width => 14, :height => 14, :border => 0, :align => "absmiddle")
  end
  
  def example_link(parselet)
    link_to h(parselet.pattern), parselet.example_url, :class => "url stop_prop", :target => '_blank'
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
      <div class='show_code'>
        <pre class="brush: #{brush}; light: true#{"; #{options[:options]}" if options[:options]}">#{h(options[:content] || capture(&block))}</pre>
      </div>
    STR
    puts "hi"
    options[:content].nil? ? concat(out) : out
  end
  
  def menu_option(name, url, &block)
    out = "<li#{" class='selected'" if current_page?(url)}>"
    out += "#{link_to_unless_current name, url}"
    out += capture(&block) if block_given?
    out += "</li>"
    block_given? ? concat(out) : out
  end
  
  def result_item(url, &block)
    url = url_for(url) unless url.is_a?(String)
    url = escape_javascript url
    concat <<-STR
      <li onclick="window.location = '#{url}'; return false;">
        <div>
          #{capture &block}
        </div>
      </li>
    STR
  end
    
  def thumb(object, link = nil)
    is_model = object.is_a?(ActiveRecord::Base)
    url = object.respond_to?(:url) ? object.url : object.to_s
    img = image_tag Thumbnail.path_for(url), :class => "thumb", :border => 0, :align => "absmiddle"
    link ||= object if is_model
    link ? link_to(img, link) : img
  end
  
  def comments(model, small = false)
    link_to icon("balloons") + (small ? "<span class=count id='comments_#{dom_id(model)}'> #{model.comments_count}</span>" : " comments (#{model.comments_count})"), {:controller => "comments", :id => model.id, :type => model.class}, :class => "comments_link stop_prop", :rel => "facebox"
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
