function ParseletEditorBase() {}

function ParseletEditor(wrapped, result, form, parseletUrl) {
  if (wrapped == null || (wrapped.get && wrapped.get(0) == null)) throw "Must provide an element to wrap.";
  this.simple = $(wrapped);
  this.result = $(result)
  this.parseletUrl = parseletUrl;
  this.form = $(form);
  this.helpful = $('<div>');
}
ParseletEditor.prototype = new ParseletEditorBase();

ParseletEditor.prototype.showHelpful = function() {
  this.simple.hide();
  this.result.hide();
  this.helpful.show();

  this.tryParselet();
};

ParseletEditor.prototype.showSimple = function() {
  this.helpful.hide();
  this.result.hide();
  this.simple.show();
};

ParseletEditor.prototype.showResult = function() {
  this.simple.hide();
  this.helpful.hide();
  this.result.show();
};


ParseletEditor.prototype.tryParselet = function() {
  var self = this;
	$.post(this.parseletUrl, this.form.serialize(), function(data) {
	  self.result.val(JSON.stringify(data, null, 2));
	}, "json");
};
