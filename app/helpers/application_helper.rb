require 'digest/md5'
require "cgi"
require "ostruct"
  
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def icon(name, alt = nil, directory = 'icons', options = {})
    options = { :border => 0, :align => "absmiddle", :alt => alt, :title => alt, :width => 16, :height => 16 }.merge(options)
    extension = (name =~ /\.\w{3,4}$/) ? '' : '.png'
    image_tag("/images/#{directory.length > 0 ? "#{directory}/" : ''}#{name}#{extension}", options)
  end
  
  def wikify(text)
    text.gsub(/\[\[([\w\-]+)\]\]/, '<a href="/parselets/\1" class="stop_prop">\1</a>')
  end
  
  STRONG_PAIR_REGEX = /<strong>.*?<\/strong>/
  STRONG_REGEX = /<\/?strong>/
  def escape_and_highlight(text, options = {})
    text = h(text).gsub(START_PARSELET_HIGHLIGHT, '<strong>').gsub(END_PARSELET_HIGHLIGHT, '</strong>')
    # Do a smart truncate that won't leave broken or hanging <strong> tags.
    if options[:truncate]
      sum = 0
      out = []
      last = nil
      text.split(STRONG_PAIR_REGEX).zip(text.scan(STRONG_PAIR_REGEX)).flatten.each do |part|
        next if part.nil?
        l = part.gsub(STRONG_REGEX, '').length
        if sum + l < options[:truncate]
          sum += l
          out << part
        else
          last = part
          break
        end
      end
      
      if last && last.length > 0
        trunk_to = options[:truncate] - sum
        trunk_to = 3 if trunk_to < 3
        if last =~ STRONG_REGEX
          last = last.gsub(STRONG_REGEX, '')
          out.join('') + '<strong>' + truncate(last, :length => trunk_to) + '</strong>'
        else
          out.join('') + truncate(last, :length => trunk_to)
        end
      else
        out.join('')
      end
    else
      text
    end
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
  
  def favorite(favoritable, show_text = true)
    if logged_in?
      preloaded = favoritable.respond_to?(:user_favorited)
      if (preloaded && favoritable.user_favorited) || (!preloaded && Favorite.find_for_favoritable(favoritable, current_user))
        <<-STR
          <div class="favorited stop_prop" favoritable_type="#{favoritable.class}" favoritable_id="#{favoritable.id}">
            <a href="#" onclick="return false;">#{icon("heart", "You have favorited this.  Click to unfavorite.")}</a>
            <a href="#" onclick="return false;" class='fav_text'>#{"favorited" if show_text}</a>
          </div>
        STR
      else
        <<-STR
          <div class="not_favorited stop_prop" favoritable_type="#{favoritable.class}" favoritable_id="#{favoritable.id}">
            <a href="#" onclick="return false;">#{icon("heart_empty", "Click to favorite this.")}</a>
            <a href="#" onclick="return false;" class='fav_text'>#{"favorite" if show_text}</a>
          </div>
        STR
      end
    else
      ''
    end
  end
  
  def empty_icon
    image_tag("/images/spacer.gif", :width => 14, :height => 14, :border => 0, :align => "absmiddle")
  end
  
  def example_link(parselet)
 link_to(parselet.pretty_example_url, parselet.example_url, :class => "url stop_prop", :title => "Keys: " + parselet.pattern_keys.map{|k| h k }.join(", "))
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
#    onclick="window.location = '#{url}'; return false;">
    concat <<-STR
      <li> 
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
  rescue
    "broken thumb"
  end
  
  def comments(model, options = {})
    if options[:merged]
      count = model.try(:comments_across_versions_count) || model.comments_count
    else
      count = model.comments_count
    end
    link_to icon("balloons") + (options[:small] ? "<span class=count id='comments_#{dom_id(model)}'> #{count}</span>" : " comments (#{count})"), {:controller => "comments", :id => model.id, :type => model.class, :merged => options[:merged]}, :class => "comments_link stop_prop", :rel => "facebox"
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
