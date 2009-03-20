function ParseletEditorBase() {
  this.history = [];
  this.historyPointer = -1;
  this.json = null;
  this.mode = 'helpful';
  this.findNextFocus = null;
  this.shift = false;
  this.PATH_CLEANUP_REGEX_PAREN = /^([^\(]*)\(.*$/g;
  this.PATH_CLEANUP_REGEX_OPTIONS = /[\?\!]+$/g;
  this.last_result_data = null;
  this.trying_parselet = null;
}

function ParseletEditor(wrapped, result, helpful, form, parseletUrl, undo, redo, result_loading_img) {
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
  this.result_loading_img = result_loading_img;
  this.reloadFromSimple();
  this.saveToSimple();
  this.simple.blur(function() { self.setUndoRedoButtons(); });
  this.saveSimpleState();
  this.tryParselet();
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
  if (this.trying_parselet == null || this.trying_parselet < (new Date()).getTime() - 5000) {
    this.trying_parselet = (new Date()).getTime();
    var self = this;
    self.result_loading_img.show();
  	$.post(this.parseletUrl, this.form.serialize(), function(data) {
  	  var pp = JSON.stringify(data, this.replacer, 2);
  	  self.result.val(pp);
  	  self.showResultInHelpful(data, self.last_result_data);
      self.maybeShowErrors(data);
  	  self.last_result_data = data;
      self.result_loading_img.hide();
      self.trying_parselet = null;
  	}, "json");
  }
};

ParseletEditor.prototype.saveToSimple = function() {
  this.simpleJson(this.json);
};

ParseletEditor.prototype.maybeShowErrors = function(data) {
  var errors_div = $('#code_errors').hide();
  if (data["errors"] && data["errors"].length > 0) {
    errors_div.empty().show();
    for (var i in data["errors"]) {
      errors_div.append($('<div class="error">').text(data["errors"][i]));
    }
  }
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
    simple.value = JSON.stringify(json, this.replacer, 2);
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
  this.helpful.append('<div class="curly_bracket_rt">{</div>');
  this.build(this.json, null, null, null, this.helpful, '-');
  this.helpful.append('<div class="curly_bracket_lt">}</div>');
  this.helpful.append("<div id='code_errors' />");
  if (this.last_result_data) this.showResultInHelpful(this.last_result_data);
  this.setUndoRedoButtons();
  this.refocus();
};

ParseletEditor.prototype.refocus = function() {
  if (this.findNextFocus && this.findNextFocus != -1 && $('input').get(this.findNextFocus)) $('input').get(this.findNextFocus).focus();
};

ParseletEditor.prototype.handlePossibleChangeInHelpful = function() {
  if (this.thingsHaveChanged()) {
    this.saveToSimple();
    this.saveSimpleState();
    this.json = this.simpleJson();
    this.tryParselet();
    this.rebuild();
    return true;
  }
  return false;
};

ParseletEditor.prototype.firstValidValue = function(object) {
  if (object instanceof Array) {
    return this.firstValidValue(object[0]);
  } else if (object instanceof Object) {
    for (var i in object) {
      return this.firstValidValue(object[i]);
    }
  } else {
    return object;
  }
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
      if (json[key] instanceof Array) {
        json[key] = json[key][0];
      } else {
        json[key] = [ json[key] ];
      }
      self.handlePossibleChangeInHelpful();
      return close_menu(e);
    }));

    menu.append($('<li><a href="#" onclick="return false;">toggle object</a></li>').click(function(e) {
      if (json[key] instanceof Array) {
        if (json[key][0] instanceof Object) {
          json[key][0] = self.firstValidValue(json[key][0]);
        } else {
          json[key][0] = { "new_key": json[key][0] };
        }
      } else if (json[key] instanceof Object) {
        json[key] = self.firstValidValue(json[key]);
      } else {
        json[key] = { "new_key": json[key] };
      }
      self.handlePossibleChangeInHelpful();
      return close_menu(e);
    }));

    menu.click(function(e) { stop_prop(e); });
    menu.fadeIn(250);
    return false;
  };
};

ParseletEditor.prototype.build = function(json, parent_json, parent_key, type, elem, path) {
  var self = this;
  if (json instanceof Array) {
    this.build((json[0] || ""), json, 0, 'value', elem, path + 'AR');
  } else if (json instanceof Object) {
    var elements = $('<div class="hash"></div>');
    json["add a new key"] = json["add a new key"] || 'add a new value';
    for(var i in json) {
      var row = $('<div class="row"></div>');

      var key = $('<div class="key"></div>');
      if (i != "add a new key")
        key.append($('<div><a href="#" class="code_menu_button down" onclick="return false;">&#9660;</a></div>').
                    click(this.makeMenuFunction(json, i)));
      else
        key.append($('<div class="code_menu_button menu_placeholder">&nbsp;</div>'));
      this.build(i, json, i, 'key', key, null);
      row.append(key);

      var value = $('<div class="value"></div>');
      var lpath = path + '-' + self.cleanKeyForPath(i)
      this.build(json[i], json, i, 'value', value, lpath);

      row.append('<div class="colon">:</div>');
      if ((json[i] instanceof Array) && (json[i][0] instanceof Object)) {
        row.append('<div class="bracket">[</div>');
        row.append('<div class="curly_bracket_rt">{</div>');
        value.addClass("multilined");
        row.append(value);

        row.append('<div class="curly_bracket_lt">}</div>');
        row.append('<div class="bracket">]</div>');
        
        if (lpath) row.append($('<div class="value_result">&nbsp;</div>').attr('id', lpath));
        
      } else if (json[i] instanceof Array) {
        row.append('<div class="bracket">[</div>');
        row.append(value);
        row.append('<div class="bracket">]</div>');

        if (lpath) row.append($('<div class="value_result">&nbsp;</div>').attr('id', lpath));

      } else if (json[i] instanceof Object) {
        row.append('<div class="curly_bracket_rt">{</div>');
        value.addClass("multilined");
        row.append(value);
        row.append('<div class="curly_bracket_lt">}</div>');
      } else {
        row.append(value);
        if (lpath) row.append($('<div class="value_result">&nbsp;</div>').attr('id', lpath));
      }
      
      elements.append(row);
    }
    elem.append(elements);
  } else {
    var new_row = json == "new_key" || json == "add a new key" || json == "add a new value";

    var blur = function(elem, force_refocus) {
      var elem = $(elem);
      if (elem.val() == '') {
        if(type == 'key') {
          elem.val('add a new key');
        } else {
          elem.val("add a new value");
        }
        elem.addClass('new_row');
      } else {
        if(type == 'key') {
          var new_key = elem.val();
          if (new_key != parent_key) {
            self.orderedKeyRename(parent_json, parent_key, new_key);
          }
        } else {
          parent_json[parent_key] = elem.val();
        }
        if (elem.val() == 'new_key') elem.addClass('new_row');
      }
      if (!self.handlePossibleChangeInHelpful()) {
        if (force_refocus) self.refocus();
      }
    };

    // Crazyness to get focus, tab, enter, shift-tab, clicks, etc. to work hopefully correctly on rebuilds.
    elem.append($('<input type="text"' + (new_row ? ' class="new_row"' : '') + '/>').val(json).blur(function(e) {
      blur(this);
    }).focus(function() {
      if (new_row) $(this).val('').removeClass('new_row');
    }).keydown(function(e) {
      if (e.keyCode == 16) {
        self.shift = true;
      } else {
        if (e.keyCode == 9 || e.keyCode == 13) { // Tab and enter
          self.setFocus(this);
          if (self.findNextFocus != -1) {
            if (self.shift)
              self.findNextFocus -= 1;
            else
              self.findNextFocus += 1;
          }
          blur(this, true);
          return false;
        } else {
          self.findNextFocus = null;
        }
      }
    }).keyup(function(e) {
      if (e.keyCode == 16) self.shift = false;
    }).mousedown(function(e) {
      self.setFocus(this);
    }));
  }
};

ParseletEditor.prototype.setFocus = function(elem) {
  this.findNextFocus = $.inArray(elem, $.makeArray($('input')));
};

ParseletEditor.prototype.cleanKeyForPath = function(i) {
  return i.replace(this.PATH_CLEANUP_REGEX_PAREN, '$1').replace(this.PATH_CLEANUP_REGEX_OPTIONS, '');
};

ParseletEditor.prototype.showResultInHelpful = function(data, old_data, path) {
  if (!path) {
    path = '-';
    $('.value_result, .array_result').text('');
  }
  var self = this;
  var t = function(obj, index) { try { return obj[index]; } catch(e) { return null; } };

  if (data instanceof Array) {
    var elem = document.getElementById(path);
    if (elem) {
      var num_as_word = (data.length == 1) ? " entry" : " entries";
      if (typeof data[0] === "string") {
        $(elem).text("// " + data.length + num_as_word + ", first: " + self.truncate(data[0]));
      } else {
        $(elem).text("// " + data.length + num_as_word);
      }
      
      if (old_data && (old_data.length != data.length || (typeof data[0] === "string" && old_data[0] != data[0])))
        $(elem).animate({ 'backgroundColor': '#FFFF00' }, 500, function(e) { $(this).animate({ 'backgroundColor': '#FFF9DB' }, 500); });
    }

    this.showResultInHelpful(data[0], t(old_data, 0), path + 'AR')
  } else if (data instanceof Object) {
    for (var i in data) {
      this.showResultInHelpful(data[i], t(old_data, i), path + '-' + self.cleanKeyForPath(i))
    }
  } else {
    var elem = document.getElementById(path);
    if (elem) {
      $(elem).text("// " + self.truncate(data));
      if (old_data && old_data != data)
        $(elem).animate({ 'backgroundColor': '#FFFF00' }, 500, function(e) { $(this).animate({ 'backgroundColor': '#FFF9DB' }, 500); });
    }
  }
};

ParseletEditor.prototype.truncate = function(str, length, ending) {
  if (!length) length = 150;
  if (!ending) ending = '...';
  if (str.length > length) {
    return str.substring(0, length) + ending;
  } else {
    return str;
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

ParseletEditor.prototype.replacer = function(key, value) {
  if (key == 'add a new key') return undefined;
  return value;
};

ParseletEditor.prototype.thingsHaveChanged = function() {
  return (this.json && JSON.stringify(this.json, this.replacer, 2) != JSON.stringify(this.simpleJson(), this.replacer, 2));
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
  if (JSON.stringify(this.json, this.replacer, 2) != this.simple.get(0).value) this.undo_button.removeClass('disabled');
};
