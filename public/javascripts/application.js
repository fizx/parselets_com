function re_eval(obj) {
  new Ajax.Request('/parselets/code/1', {
    asynchronous:true, 
    evalScripts:true, 
    parameters:Form.serialize(obj.form)
  }); 
  return false;
}