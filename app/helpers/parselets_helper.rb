module ParseletsHelper
  ENTER = false # "window.event.keyCode == 13"
  
  def key_field(path, name, key, value, edit = true)
    if edit
      menu(value, path, name) + 
      %[
        <input class="key" type="text" name="#{h path}[#{h name}][key]" value="#{h key}"
        onkeypress="if(#{ENTER}) return false;" onchange="this.dirty=true" onblur="if(this.dirty)re_eval()">
       ] 
   else
     %[
       &quot;<span class="base">#{h key.base}</span><span class="filter">#{h key.filter}</span>&quot;
      ]
   end
  end
  
  def value_handler(path, name, value, edit = true)
    case value
    when Hash
      render "/parselets/helpful", :path => path, :data => value, :edit => edit
    when Array
      multi_field(path, name) + "[" + value_handler(path, name, value.first, edit) + "]"
    when String
      value_field(path, name, value, edit)
    end
  end
  
  def value_field(path, name, value = "", edit = true)
    
    if edit
      %[<input class="value" type="text" name="#{h path}[#{h name}][value]" value="#{h value}"
          onkeypress="if(#{ENTER}) return false;" onchange="this.dirty=true" onblur="if(this.dirty)re_eval()">]
    else
      %[<span class="filter">#{h value}</span>#{h value.value}]
    end
  end
  
  def multi_field(path, name)
    %[<input type="hidden" name="#{h path}[#{h name}][multi]" value="true" />]
  end
  
  def menu(value, path, name)
    puts path
    is_root = !name
    is_arr = value.is_a?(Array)
    is_obj = [value].flatten[0].is_a?(Hash)
    items = []
    
    # items << link_to_command("add sprig", "sprig", path, name) 
    
    unless is_root
    
      if is_arr 
        items << link_to_command("multi-valued", "unmultify", path, name, :checked) 
      else
        items << link_to_command("multi-valued", "multify", path, name, :unchecked)
      end
    
      if is_obj
        items << link_to_command("object", "unobjectify", path, name, :checked) 
      else
        items << link_to_command("object", "objectify", path, name, :unchecked)
      end
    
      items << link_to_command("delete", "delete", path, name)    
    end
    
    render_menu items
  end
  
  def render_menu(items)
    %[
      <span style="position:relative">
        <a href="#" class="down" onclick="menu_click(this);return false;">&#9660;</a><ul class="menu" style="display:none">
          <a href="#" class="x" onclick="menu_click(this);return false;">x</a>
        #{items.map{|i| "<li>#{i}</li>"}.join('')}
        </ul>
      </span>
    ]
  end
  

  
  def space(str)
    "&nbsp;" * [(10 - str.length), 0].max
  end
  
  def link_to_command(text, command, path, i, check = nil)
    cmd = "$('root-command').value='#{path},#{i},#{command}';re_eval()"
    box = case check
          when :checked:   %[<input type=checkbox checked="checked" onclick="#{cmd}"/>]
          when :unchecked: %[<input type=checkbox onclick="#{cmd}"/>]
          else;            %[<input type=checkbox style="visibility:hidden"/>]
          end
    
    link_to_function(box + " " + text, cmd)
  end
  
  def emptyish(hash)
    h = hash.dup
    h.each do |k, v|
      h.delete(k) if k.blank? && v.blank?
    end
    h.empty?
  end
end
