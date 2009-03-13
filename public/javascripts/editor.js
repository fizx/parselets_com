function ParseletEditorBase() {
  this.history = [];
  this.historyPointer = -1;
  this.json = null;
  this.mode = 'helpful';
  this.result_json = null;
}

function ParseletEditor(wrapped, result, form, parseletUrl) {
  if (wrapped == null || (wrapped.get && wrapped.get(0) == null)) throw "Must provide an element to wrap.";
  this.simple = $(wrapped);
  this.result = $(result)
  this.parseletUrl = parseletUrl;
  this.form = $(form);
  this.helpful = $('<div>');
  this.reloadFromSimple();
  this.saveSimpleState();
}
ParseletEditor.prototype = new ParseletEditorBase();

ParseletEditor.prototype.hideAll = function() {
  this.simple.hide();
  this.result.hide();
  this.helpful.hide();
};

ParseletEditor.prototype.showHelpful = function() {
  if (this.reloadFromSimple()) {
    this.saveSimpleState();
    this.hideAll();
    this.rebuild();
    this.helpful.show();
    this.mode = 'helpful';
    return true;
  }
  return false;
};

ParseletEditor.prototype.showSimple = function() {
  this.saveToSimple();
  this.hideAll();
  this.simple.show();
  this.mode = 'simple';
  return true;
};

ParseletEditor.prototype.showResult = function() {
  this.saveToSimple();
  if (this.reloadFromSimple()) {
    this.saveSimpleState();
    this.hideAll();
    this.result.show();
    this.mode = 'result';
    return true;
  }
  return false;
};

ParseletEditor.prototype.tryParselet = function() {
  var self = this;
	$.post(this.parseletUrl, this.form.serialize(), function(data) {
	  self.result_json = data;
	  self.result.val(JSON.stringify(data, null, 2));
	}, "json");
};

ParseletEditor.prototype.reloadFromSimple = function() {
  if (this.simpleIsValid()) {
    this.json = this.simpleJson();
    return true;
  } else {
    alert("Sorry, there appears to be an error in your JSON input.  Please fix it before continuing.");
    return false;
  }
};

ParseletEditor.prototype.saveToSimple = function() {
  if (this.mode != 'simple') this.simpleJson(this.json);
};

ParseletEditor.prototype.simpleIsValid = function() {
  try {
    JSON.parse(this.simple.get(0).value);
    return true;
  } catch(e) {
    return false;
  }
};

ParseletEditor.prototype.simpleJson = function(json) {
  var simple = this.simple.get(0);
  if (json) {
    simple.value = JSON.stringify(json, null, 2);
    return json;
  } else {
    if (simple.value.length == 0) return this.simpleJson({});
    try {
      simple.value = simple.value.replace(/((^|[^\\])(\\\\)*)\\n/g, '$1\\\\n').replace(/((^|[^\\])(\\\\)*)\\t/g, '$1\\\\t');
      return JSON.parse(simple.value);
    } catch(e) {
      alert("Got bad JSON from text.");
    }
  }
};

ParseletEditor.prototype.rebuild = function() {
  // var changed = this.thingsHaveChanged();
  //this.saveState();
  // this.reloadFromSimple(); // Is this needed?
  if (this.mode == 'helpful') {
    
  }
};

ParseletEditor.prototype.thingsHaveChanged = function() {
  return (this.json && JSON.stringify(this.json, null, 2) != this.simple.get(0).value);
};

ParseletEditor.prototype.historyTruncate = function() {
  if (this.historyPointer + 1 < this.history.length) {
    this.history.splice(this.historyPointer + 1, this.history.length - this.historyPointer);
  }
};

ParseletEditor.prototype.saveSimpleStateIfChanged = function() {
  if (this.thingsHaveChanged()) {
    if (this.simpleIsValid()) {
      this.saveSimpleState();
    } else {
      if (confirm("The current parselet is malformed.  If you continue, the parselet will be reverted to the last valid state.  Do you wish to continue?")) {
        this.historyPointer += 1;
        return true;
      } else {
        return false;
      }
    }
  }
  return true;
};

ParseletEditor.prototype.restore = function() {
  if (this.history[this.historyPointer]) {
    this.simple.get(0).value = this.history[this.historyPointer];
    this.reloadFromSimple();
    this.rebuild();
  }
};

ParseletEditor.prototype.saveSimpleState = function() {
  if (this.json) {
    var text = this.simple.get(0).value;
    if (this.history[this.historyPointer] != text) {
      this.historyTruncate();
      this.history.push(text);
      this.historyPointer += 1;
    }
  }
};

ParseletEditor.prototype.undo = function() {
  if (this.saveSimpleStateIfChanged()) {
    if (this.historyPointer > 0) this.historyPointer -= 1;
    this.restore();
  }
};
      
ParseletEditor.prototype.redo = function() {
  if (this.historyPointer + 1 < this.history.length) {
    if (this.saveSimpleStateIfChanged()) {
      this.historyPointer += 1;
      this.restore();
    }
  }
};
