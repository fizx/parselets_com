// var is_helpful = true;
// function helpful(bool) {
//  if(bool == is_helpful) return false;
//  is_helpful = bool;
//  if(is_helpful) {
//    $('hyes').className = "selected";
//    $('hno').className = "";
//    $('editor_helpful').value = "true"
//  } else {
//    $('hyes').className = "";
//    $('hno').className = "selected";
//    $('editor_helpful').value = ""
//  }
//  $("root-command").value = "switch_mode"
//  re_eval();
// }
// 
// function menu_click(obj) {
//  $$('ul.menu').each(function(e){
//    e == obj.next() ? e.toggle() : e.hide();
//  });
// }
// 
// function re_eval() {
//  var focus = true; // TODO: check key events for tab / enter
//   
//   new Ajax.Request('/parselet_code', {
//     asynchronous:true, 
//     evalScripts:true, 
//     parameters:Form.serialize("parselet_form"),
//    onComplete: function(a, b, c){
//      if(focus) {
//        var field = $('parselet_form').getInputs('text').find(function(e){ 
//           return e.name.startsWith("root") && $F(e) == ""; 
//        });
//        var alt_field = $('parselet_form').getInputs('text').find(function(e){ 
//            return e.name.startsWith("root") && $F(e) == "" && e.className == "key-auto"; 
//          });
//        field = field || alt_field;
//        field && field.focus();
//      }
//    }
//    
//   }); 
//   return false;
// }
// 
// function re_eval() {
//  var focus = true; // TODO: check key events for tab / enter
//   
//   new Ajax.Request('/parselet_code', {
//     asynchronous:true, 
//     evalScripts:true, 
//     parameters:Form.serialize("parselet_form"),
//    onComplete: function(a, b, c){
//      if(focus) {
//        var field = $('parselet_form').getInputs('text').find(function(e){ 
//           return e.name.startsWith("root") && $F(e) == ""; 
//        });
//        var alt_field = $('parselet_form').getInputs('text').find(function(e){ 
//            return e.name.startsWith("root") && $F(e) == "" && e.className == "key-auto"; 
//          });
//        field = field || alt_field;
//        field && field.focus();
//      }
//    }
//    
//   }); 
//   return false;
// }
