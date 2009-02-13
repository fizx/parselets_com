module ParseletsHelper
  ENTER = false # "window.event.keyCode == 13"
  
  def key_field(path, name, value = "", klass = "key")
    type = value.blank? ? "text" : "hidden"
    base = %[
      <input class="#{klass}" type="#{type}" name="#{h path}[#{h name}][key]" value="#{h value}"
      onkeypress="if(#{ENTER}) return false;" onfocus="this.orig=this.value" onblur="re_eval(this)">
      #{h value}
     ] 
   if klass == "key-auto"
     base
   else
     base + menu
     
     
     
     # %/
     #       [ #{link_to "sp"} ]
     #       [ #{link_to "fil"} ]
     #      /
   end
  end
  
  def menu
    %[
      <span style="position:relative">
        <a href="#" style="text-decoration:none" onclick="next().toggle();return false;">&#9660;</a><div style="display:none;position:absolute;top:10px;left:0px;width:200px;border:1px silver solid;background-color:#eee;padding:5px">hi world</div></span>
      ]
  end
  
  def auto_key_field(path, name)
    key_field(path, name, "", "key-auto")
  end
  
  def value_field(path, name, value = "")
    %[<input class="value" type="text" name="#{h path}[#{h name}][value]" value="#{h value}"
        onkeypress="if(#{ENTER}) return false;" onfocus="this.orig=this.value" onblur="re_eval(this)">]
  end
  
  def multi_field(path, name)
    %[<input type="hidden" name="#{h path}[#{h name}][multi]" value="true" />]
  end
  
  def space(str)
    "&nbsp;" * (10 - str.length)
  end
  
  def link_to_command(text, command, path, i)
    link_to_function text, "$('root-command').value='#{path},#{i},#{command}';re_eval(this)"
  end
  
  def emptyish(hash)
    h = hash.dup
    h.each do |k, v|
      h.delete(k) if k.blank? && v.blank?
    end
    h.empty?
  end
end
