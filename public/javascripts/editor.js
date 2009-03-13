function ParseletEditorBase() {
  this.history = [];
  this.historyPointer = -1;
  this.json = null;
  this.mode = 'helpful';
  this.result_json = null;
}

function ParseletEditor(wrapped, result, helpful, form, parseletUrl) {
  if (wrapped == null || (wrapped.get && wrapped.get(0) == null)) throw "Must provide an element to wrap.";
  this.simple = $(wrapped);
  this.result = $(result)
  this.parseletUrl = parseletUrl;
  this.form = $(form);
  this.helpful = helpful;
  this.reloadFromSimple();
  this.saveToSimple();
  this.saveSimpleState();
  this.rebuild();
}
ParseletEditor.prototype = new ParseletEditorBase();

ParseletEditor.prototype.hideAll = function() {
  this.simple.hide();
  this.result.hide();
  this.helpful.hide();
};

ParseletEditor.prototype.showHelpful = function() {
  if (this.reloadFromSimple()) {
    this.mode = 'helpful';
    this.saveSimpleState();
    this.hideAll();
    this.helpful.show();
    return true;
  }
  return false;
};

ParseletEditor.prototype.showSimple = function() {
  this.mode = 'simple';
  this.saveToSimple();
  this.hideAll();
  this.simple.show();
  return true;
};

ParseletEditor.prototype.showResult = function() {
  this.saveToSimple();
  if (this.reloadFromSimple()) {
    this.mode = 'result';
    this.saveSimpleState();
    this.hideAll();
    this.result.show();
    return true;
  }
  return false;
};

ParseletEditor.prototype.tryParselet = function() {
  var self = this;
	$.post(this.parseletUrl, this.form.serialize(), function(data) {
	  self.result_json = data;
	  self.result.val(JSON.stringify(data, null, 2));
	  self.rebuild();
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
  if (this.mode != 'helpful') return;
  // var changed = this.thingsHaveChanged();
  // if (changed || force) {
    // this.saveToSimple();
    // this.saveSimpleState();
    // if (changed) this.tryParselet();
    this.helpful.empty();
    this.build(this.json, this.helpful, this.result_json);
  // }
};

ParseletEditor.prototype.build = function(json, parent, result) {
  var r = function(struct, index) { try { return struct[index]; } catch(e) { return null; } };

  if (json instanceof Array) {
    // parent.append('<div class="bracket">[</div>');
    this.build((json[0] || ""), parent, r(result, 0));
    // parent.append('<div class="bracket">]</div>');
  } else if (json instanceof Object) {
    var elements = $('<div class="hash"></div>');
    for(var i in json) {
      var row = $('<div class="row"></div>');

      var key = $('<div class="key"></div>');
      key.append($('<div><a href="#" class="code_menu_button down" onclick="return false;">&#9660;</a></div>').click(function(e) {
        var offset = $(this).offset();
        var menu = $('<ul class="menu"></ul>');
        menu.css('top', offset.top + 'px').css('left', offset.left + 'px');
        menu.append($('<li><a href="#" onclick="return false;">delete</a></li>').click(function() {
          console.log("delete");
        }));

        
        menu.click(function(e) {
          return stop_prop(e);
        });
        
        var doc_click = function() { console.log("doc click"); menu.remove(); $('body').unbind('click', doc_click); };        
        $('body').bind('click', doc_click);
        $(this).append(menu);
        return false;
      }));
      this.build(i, key);
      row.append(key);

      var value = $('<div class="value"></div>');
      this.build(json[i], value, r(result, i));

      row.append('<div class="colon">:</div>');
      if ((json[i] instanceof Array) && (json[i][0] instanceof Object)) {
        row.append('<div class="bracket">[</div>');
        row.append('<div class="curly_bracket_rt">{</div>');
        value.addClass("multilined");
        row.append(value);
        row.append('<div class="curly_bracket_lt">}</div>');
        row.append('<div class="bracket">]</div>');
      } else if (json[i] instanceof Array) {
        row.append('<div class="bracket">[</div>');
        row.append(value);
        row.append('<div class="bracket">]</div>');
      } else if (json[i] instanceof Object) {
        row.append('<div class="curly_bracket_rt">{</div>');
        row.append(value);
        row.append('<div class="curly_bracket_lt">}</div>');
      } else {
        row.append(value);
      }
      
      elements.append(row);
    }
    parent.append(elements);
  } else {
    parent.append($('<input type="text" />').val(json));
  }
};







ParseletEditor.prototype.thingsHaveChanged = function() {
  return (this.json && JSON.stringify(this.json, null, 2) != JSON.stringify(this.simpleJson(), null, 2));
};

ParseletEditor.prototype.historyTruncate = function() {
  if (this.historyPointer + 1 < this.history.length) {
    this.history.splice(this.historyPointer + 1, this.history.length - this.historyPointer);
  }
};

ParseletEditor.prototype.saveSimpleStateIfChanged = function() {
  if (this.simpleIsValid()) {
    if (this.thingsHaveChanged()) {
      this.saveSimpleState();
    }
  } else {
    if (confirm("The current parselet is malformed.  If you continue, the parselet will be reverted to the last valid state.  Do you wish to continue?")) {
      this.historyPointer += 1;
      return true;
    } else {
      return false;
    }
  }
  return true;
};

ParseletEditor.prototype.restore = function() {
  if (this.history[this.historyPointer]) {
    this.simple.get(0).value = this.history[this.historyPointer];
    this.reloadFromSimple();
    this.tryParselet();
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
      
      // Also do a few other needed things.
      this.tryParselet();
      this.rebuild();
    }
  }
};

ParseletEditor.prototype.undo = function() {
  if (this.saveSimpleStateIfChanged()) {
    if (this.historyPointer > 0) {
      this.historyPointer -= 1;
      this.restore();
    }
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
