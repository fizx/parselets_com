function ParseletEditorBase() {
  this.history = [];
  this.historyPointer = -1;
  this.json = null;
  this.mode = 'helpful';
  this.result_json = null;
}

function ParseletEditor(wrapped, result, helpful, form, parseletUrl, undo, redo) {
  if (wrapped == null || (wrapped.get && wrapped.get(0) == null)) throw "Must provide an element to wrap.";
  var self = this;
  this.simple = $(wrapped);
  this.result = $(result);
  this.undo_button = undo;
  this.redo_button = redo;
  this.setUndoRedoButtons();
  this.parseletUrl = parseletUrl;
  this.form = $(form);
  this.helpful = helpful;
  this.reloadFromSimple();
  this.saveToSimple();
  this.simple.blur(function() { self.setUndoRedoButtons(); });
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
  if (this.handleTransition()) {
    this.mode = 'helpful';
    this.hideAll();
    this.helpful.show();
    return true;
  }
  return false;
};

ParseletEditor.prototype.showSimple = function() {
  if (this.handleTransition()) {
    this.mode = 'simple';
    this.hideAll();
    this.simple.show();
    return true;
  }
  return false;
};

ParseletEditor.prototype.showResult = function() {
  if (this.handleTransition()) {
    this.mode = 'result';
    this.hideAll();
    this.result.show();
    return true;
  }
  return false;
};

ParseletEditor.prototype.handleTransition = function() {
  if (this.mode == 'simple') {
    if (!this.simpleIsValid()) {
      alert("Sorry, there appears to be an error in your JSON input.  Please fix it before continuing.");
      return false;
    }
    
    if (this.saveSimpleState()) {
      this.reloadFromSimple();
      this.tryParselet();
    }
  } else {
    this.handlePossibleChangeInHelpful();
  }
  return true;
};

ParseletEditor.prototype.tryParselet = function() {
  var self = this;
	$.post(this.parseletUrl, this.form.serialize(), function(data) {
	  self.result_json = data;
	  var pp = JSON.stringify(data, null, 2);
	  if (pp != self.result.val()) {
  	  self.result.val(pp);
  	  self.rebuild();
	  }
	}, "json");
};

ParseletEditor.prototype.saveToSimple = function() {
  this.simpleJson(this.json);
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
  this.helpful.empty();
  this.build(this.json, null, null, null, this.helpful, this.result_json);
  this.setUndoRedoButtons();
};

ParseletEditor.prototype.handlePossibleChangeInHelpful = function() {
  if (this.thingsHaveChanged()) {
    this.saveToSimple();
    this.saveSimpleState();
    this.json = this.simpleJson();
    this.tryParselet();
    this.rebuild();
  }
};

ParseletEditor.prototype.functionWrap = function(e) {
  return function() {
    return e;
  };
};

// Oh the hoops you have to jump through with closures sometimes...
ParseletEditor.prototype.makeMenuFunction = function(json, key) {
  var self = this;
  return function(e) {
    var offset = $(this).offset();
    var menu = $('<ul class="menu"></ul>');
    var cover = $('<div class="cover"></div>').css('width', $('body').width() + 'px').css('height', $('body').height() + 'px');
    var close_menu = function(e) {
      cover.remove();
      menu.fadeOut(250, function() { $(this).remove() });
      if (e) stop_prop(e);
      return false;
    };
    cover.bind('click', close_menu);
    $('body').append(cover).append(menu.hide());
    menu.css('top', (offset.top + 10) + 'px').css('left', (offset.left + 10) + 'px');


    menu.append($('<li><a href="#" onclick="return false;">delete</a></li>').click(function(e) {
      delete json[key];
      self.handlePossibleChangeInHelpful();
      return close_menu(e);
    }));
    
    menu.append($('<li><a href="#" onclick="return false;">toggle multivalued</a></li>').click(function(e) {
      delete json[key];
      self.handlePossibleChangeInHelpful();
      return close_menu(e);
    }));

    menu.append($('<li><a href="#" onclick="return false;">toggle object</a></li>').click(function(e) {
      delete json[key];
      self.handlePossibleChangeInHelpful();
      return close_menu(e);
    }));
    

    menu.click(function(e) { stop_prop(e); });
    menu.fadeIn(250);
    return false;
  };
};

ParseletEditor.prototype.build = function(json, parent_json, parent_key, type, elem, result) {
  var self = this;
  var r = function(struct, index) { try { return struct[index]; } catch(e) { return null; } };

  if (json instanceof Array) {
    this.build((json[0] || ""), json, 0, 'value', elem, r(result, 0));
  } else if (json instanceof Object) {
    var elements = $('<div class="hash"></div>');
    for(var i in json) {
      var row = $('<div class="row"></div>');

      var key = $('<div class="key"></div>');
      key.append($('<div><a href="#" class="code_menu_button down" onclick="return false;">&#9660;</a></div>').
                  click(this.makeMenuFunction(json, i)));
      this.build(i, json, i, 'key', key);
      row.append(key);

      var value = $('<div class="value"></div>');
      this.build(json[i], json, i, 'value', value, r(result, i));

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
    elem.append(elements);
  } else {
    elem.append($('<input type="text" />').val(json).blur(function() {
      if(type == 'key') {
        var new_key = $(this).val();
        if (new_key != parent_key) {
          self.orderedKeyRename(parent_json, parent_key, new_key);
        }
      } else {
        parent_json[parent_key] = $(this).val();
      }
      self.handlePossibleChangeInHelpful();
    }));
  }
};




ParseletEditor.prototype.orderedKeyRename = function(json, old_key, new_key) {
  for(var i in json) {
    var tmp = json[i];
    delete json[i];
    if (i == old_key) {
      json[new_key] = tmp;
    } else {
      json[i] = tmp;
    }
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
    this.saveSimpleState();
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

ParseletEditor.prototype.reloadFromSimple = function() {
  this.json = this.simpleJson();
  this.rebuild();
};

ParseletEditor.prototype.restore = function() {
  if (this.history[this.historyPointer]) {
    this.simple.get(0).value = this.history[this.historyPointer];
    this.reloadFromSimple();
    this.tryParselet();
    this.setUndoRedoButtons();
  }
};

ParseletEditor.prototype.saveSimpleState = function() {
  if (this.json) {
    var text = this.simple.get(0).value;
    if (this.history[this.historyPointer] != text) {
      this.historyTruncate();
      this.history.push(text);
      this.historyPointer += 1;
      return true;
    }
  }
  return false;
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

ParseletEditor.prototype.setUndoRedoButtons = function() {
  this.undo_button.addClass('disabled');
  this.redo_button.addClass('disabled');

  if (this.historyPointer + 1 < this.history.length) this.redo_button.removeClass('disabled');
  if (this.historyPointer > 0) this.undo_button.removeClass('disabled');
  if (JSON.stringify(this.json, null, 2) != this.simple.get(0).value) this.undo_button.removeClass('disabled');
  
  console.log("called");
};
