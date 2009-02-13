function re_eval(obj) {
  if(obj.orig == obj.value && $F("root-command") == "") return false;
  
  new Ajax.Request('/parselets/code/1', {
    asynchronous:true, 
    evalScripts:true, 
    parameters:Form.serialize("parselet_form")
  }); 
  return false;
}