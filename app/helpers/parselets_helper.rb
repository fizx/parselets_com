module ParseletsHelper
  def key_field(path, name, value = "")
    type = value.blank? ? "text" : "hidden"
    %[
      <input class="key" type="#{type}" name="#{h path}[#{h name}][key]" value="#{h value}"
      onkeypress="if(window.event.keyCode == 13) return false;" onblur="re_eval(this)">
      #{h value}
     ]
  end
  
  def value_field(path, name, value = "")
    %[<input class="key" type="text" name="#{h path}[#{h name}][value]" value="#{h value}"
        onkeypress="if(window.event.keyCode == 13) return false;" onblur="re_eval(this)">]
  end
  
  def multi_field(path, name)
    %[<input type="hidden" name="#{h path}[#{h name}][multi]" value="true" />]
  end
  
  def emptyish(hash)
    h = hash.dup
    h.each do |k, v|
      h.delete(k) if k.blank? && v.blank?
    end
    h.empty?
  end
end
