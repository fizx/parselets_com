function ParseletEditorBase() {
  this.history = [];
  this.historyPointer = -1;
  this.builderShowing = true;
  this.ADD_IMG = 'ParseletEditor/add.png';
  this.DELETE_IMG = 'ParseletEditor/delete.png';
  this._doTruncation = true;
}

function ParseletEditor(wrapped, width, height) {
  if (wrapped == null || (wrapped.get && wrapped.get(0) == null)) throw "Must provide an element to wrap.";
  var width = width || 600;
  var height = height || 300;
  this.wrapped = jQuery(wrapped);

  this.wrapped.wrap('<div class="container"></div>');
  this.container = jQuery(this.wrapped.parent());
  this.container.width(width).height(height);
  this.wrapped.width(width).height(height);
  this.wrapped.hide();
  this.container.css("position", "relative");
  this.doAutoFocus = false;
  this.editingUnfocused();
  
  this.rebuild();
  
  return this;
}
ParseletEditor.prototype = new ParseletEditorBase();

ParseletEditor.prototype.braceUI = function(key, struct) {
  var self = this;
  return jQuery('<a class="icon" href="#"><strong>{</strong></a>').click(function(e) {
    struct[key] = { "??": struct[key] };
    self.doAutoFocus = true;
    self.rebuild();
    return false;
  });
};

ParseletEditor.prototype.bracketUI = function(key, struct) {
  var self = this;
  return jQuery('<a class="icon" href="#"><strong>[</a>').click(function(e) {
    struct[key] = [ struct[key] ];
    self.doAutoFocus = true;
    self.rebuild();
    return false;
  });
};

ParseletEditor.prototype.deleteUI = function(key, struct, fullDelete) {
  var self = this;
  return jQuery('<a class="icon" href="#"><img src="' + this.DELETE_IMG + '" border=0/></a>').click(function(e) {
    if (!fullDelete) {
      var didSomething = false;
      if (struct[key] instanceof Array) {
        if(struct[key].length > 0) {
          struct[key] = struct[key][0];
          didSomething = true;
        }
      } else if (struct[key] instanceof Object) {
        for (var i in struct[key]) {
          struct[key] = struct[key][i];
          didSomething = true;
          break;
        }
      }
      if (didSomething) {
        self.rebuild();
        return false;
      }
    }
    if (struct instanceof Array) {
      struct.splice(key, 1);
    } else {
      delete struct[key];
    }
    self.rebuild();
    return false;
  });
};

ParseletEditor.prototype.addUI = function(struct) {
  var self = this;
  return jQuery('<a class="icon" href="#"><img src="' + this.ADD_IMG + '" border=0/></a>').click(function(e) {
    if (struct instanceof Array) {
      struct.push('??');
    } else {
      struct['??'] = '??';
    }
    self.doAutoFocus = true;
    self.rebuild();
    return false;
  });
};

ParseletEditor.prototype.undo = function() {
  if (this.saveStateIfTextChanged()) {
    if (this.historyPointer > 0) this.historyPointer -= 1;
    this.restore();
  }
};
      
ParseletEditor.prototype.redo = function() {
  if (this.historyPointer + 1 < this.history.length) {
    if (this.saveStateIfTextChanged()) {
      this.historyPointer += 1;
      this.restore();
    }
  }
};

ParseletEditor.prototype.showBuilder = function() {
  if (this.checkJsonInText()) {
    this.setJsonFromText();
    this.rebuild();
    this.builder.show();
    this.wrapped.hide();
    return true;
  } else {
    alert("Sorry, there appears to be an error in your JSON input.  Please fix it before continuing.");
    return false;
  }
};

ParseletEditor.prototype.showText = function() {
  this.builder.hide();
  this.wrapped.show();
};

ParseletEditor.prototype.toggleBuilder = function() {
    if(this.builderShowing){
      this.showText();
      this.builderShowing = !this.builderShowing;
    } else {
      if (this.showBuilder()) {
        this.builderShowing = !this.builderShowing;
      }
    }
};

ParseletEditor.prototype.showFunctionButtons = function() {
  if (!this.functionButtons) {
    this.functionButtons = jQuery('<div class="function_buttons"></div>');
    var self = this;
    this.functionButtons.append(jQuery('<a href="#" style="padding-right: 10px;"></a>').click(function() {
      self.undo();
      return false;
    }).text('Undo')).append(jQuery('<a href="#" style="padding-right: 10px;"></a>').click(function() {
      self.redo();
      return false;
    }).text('Redo')).append(jQuery('<a href="#" style="padding-right: 10px;"></a>').click(function() {
      self.toggleBuilder();
      return false;
    }).text('Toggle View'));
    this.container.prepend(this.functionButtons);
    this.container.height(this.container.height() + this.functionButtons.height() + 5);
  }
  if (this.functionButtons) {
    this.wrapped.css('top', this.functionButtons.height() + 5 + 'px');
    this.builder.css('top', this.functionButtons.height() + 5 + 'px');
  }
};

ParseletEditor.prototype.saveStateIfTextChanged = function() {
  if (JSON.stringify(this.json, null, 2) != this.wrapped.get(0).value) {
    if (this.checkJsonInText()) {
      this.saveState(true);
    } else {
      if (confirm("The current JSON is malformed.  If you continue, the current JSON will not be saved.  Do you wish to continue?")) {
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
    this.wrapped.get(0).value = this.history[this.historyPointer];
    this.rebuild(true);
  }
};

ParseletEditor.prototype.saveState = function(skipStoreText) {
  if (this.json) {
    if (!skipStoreText) this.storeToText();
    var text = this.wrapped.get(0).value;
    if (this.history[this.historyPointer] != text) {
      this.historyTruncate();
      this.history.push(text);
      this.historyPointer += 1;
    }
  }
};

ParseletEditor.prototype.fireChange = function() {
  jQuery(this.wrapped).trigger('change');
};

ParseletEditor.prototype.historyTruncate = function() {
  if (this.historyPointer + 1 < this.history.length) {
    this.history.splice(this.historyPointer + 1, this.history.length - this.historyPointer);
  }
};

ParseletEditor.prototype.storeToText = function() {
  this.wrapped.get(0).value = JSON.stringify(this.json, null, 2);
};

ParseletEditor.prototype.getJSONText = function() {
  this.rebuild();
  return this.wrapped.get(0).value;
};

ParseletEditor.prototype.getJSON = function() {
  this.rebuild();
  return this.json;
};

ParseletEditor.prototype.rebuild = function(doNotRefreshText) {
  if (!this.json) this.setJsonFromText();
  var changed = this.haveThingsChanged();
  if (this.json && !doNotRefreshText) {
    this.saveState();
  }
  this.cleanBuilder();
  this.setJsonFromText();
  this.alreadyFocused = false;
  this.build(this.json, this.builder, null, null, this.json);
  this.recoverScrollPosition();
  if (changed) this.fireChange();
};

ParseletEditor.prototype.haveThingsChanged = function() {
  return (this.json && JSON.stringify(this.json, null, 2) != this.wrapped.get(0).value);
}

ParseletEditor.prototype.saveScrollPosition = function() {
  this.oldScrollHeight = this.builder.scrollTop();
};

ParseletEditor.prototype.recoverScrollPosition = function() {
  this.builder.scrollTop(this.oldScrollHeight);
};

ParseletEditor.prototype.setJsonFromText = function() {
  if (this.wrapped.get(0).value.length == 0) this.wrapped.get(0).value = "{}";
  try {
    this.wrapped.get(0).value = this.wrapped.get(0).value.replace(/((^|[^\\])(\\\\)*)\\n/g, '$1\\\\n').replace(/((^|[^\\])(\\\\)*)\\t/g, '$1\\\\t');
    this.json = JSON.parse(this.wrapped.get(0).value);
  } catch(e) {
    alert("Got bad JSON from text.");
  }
};

ParseletEditor.prototype.checkJsonInText = function() {
  try {
    JSON.parse(this.wrapped.get(0).value);
    return true;
  } catch(e) {
    return false;
  }
};

ParseletEditor.prototype.logJSON = function() {
  console.log(JSON.stringify(this.json, null, 2));
};

ParseletEditor.prototype.cleanBuilder = function() {
  if (!this.builder) {
    this.builder = jQuery('<div class="builder"></div>');
    this.container.append(this.builder);
  }
  this.saveScrollPosition();
  this.builder.text('');
  
  this.builder.css("position", "absolute").css("top", 0).css("left", 0);
  this.builder.width(this.wrapped.width()).height(this.wrapped.height());
  this.wrapped.css("position", "absolute").css("top", 0).css("left", 0);
  this.showFunctionButtons();
};

ParseletEditor.prototype.updateStruct = function(struct, key, val, kind, selectionStart, selectionEnd) {
  if(kind == 'key') {
    if (selectionStart && selectionEnd) val = key.substring(0, selectionStart) + val + key.substring(selectionEnd, key.length);
    struct[val] = struct[key];
    if (key != val) delete struct[key];
  } else {
    if (selectionStart && selectionEnd) val = struct[key].substring(0, selectionStart) + val + struct[key].substring(selectionEnd, struct[key].length);
    struct[key] = val;
  }
};

ParseletEditor.prototype.getValFromStruct = function(struct, key, kind) {
  if(kind == 'key') {
    return key;
  } else {
    return struct[key];
  }
};

ParseletEditor.prototype.doTruncation = function(trueOrFalse) {
  if (this._doTruncation != trueOrFalse) {
    this._doTruncation = trueOrFalse;
    this.rebuild();
  }
};

ParseletEditor.prototype.truncate = function(text, length) {
  if (text.length == 0) return '-empty-';
  if(this._doTruncation && text.length > (length || 30)) return(text.substring(0, (length || 30)) + '...');
  return text;
};

ParseletEditor.prototype.replaceLastSelectedFieldIfRecent = function(text) {
  if (this.lastEditingUnfocusedTime > (new Date()).getTime() - 200) { // Short delay for unfocus to occur.
    this.setLastEditingFocus(text);
    this.rebuild();
  }
};

ParseletEditor.prototype.editingUnfocused = function(elem, struct, key, root, kind) {
  var self = this;

  var selectionStart = elem && elem.target.selectionStart;
  var selectionEnd = elem && elem.target.selectionEnd;

  this.setLastEditingFocus = function(text) {
    self.updateStruct(struct, key, text, kind, selectionStart, selectionEnd);
    self.json = root; // Because self.json is a new reference due to rebuild.
  };
  this.lastEditingUnfocusedTime = (new Date()).getTime();
};

ParseletEditor.prototype.edit = function(e, key, struct, root, kind){
  var self = this;
  var form = jQuery("<form></form>").css('display', 'inline');
  var input = document.createElement("INPUT");
  input.value = this.getValFromStruct(struct, key, kind);
  //alert(this.getValFromStruct(struct, key, kind));
  input.className = 'edit_field';
  var onblur = function(elem) {
    var val = input.value;
    self.updateStruct(struct, key, val, kind);
    self.editingUnfocused(elem, struct, (kind == 'key' ? val : key), root, kind);
    e.text(self.truncate(val));
    e.get(0).editing = false;
    if (key != val) self.rebuild();
    return false;
  };
  jQuery(input).blur(onblur);
  jQuery(input).keydown(function(e) {
    if (e.keyCode == 9 || e.keyCode == 13) { // Tab and enter
      self.doAutoFocus = true;
      onblur(e);
      return false;
    }
  });
  jQuery(form).submit(function(e) { self.doAutoFocus = true; onblur(e); return false;}).append(input);
  jQuery(e).html(form);
  input.focus();
};

ParseletEditor.prototype.editable = function(text, key, struct, root, kind) {
  var self = this;
  var elem = jQuery('<span class="editable" href="#"></span>').text(this.truncate(text)).click(function(e) {
    if (!this.editing) {
      this.editing = true;
      self.edit(jQuery(this), key, struct, root, kind);
    }
    return true;
  });
  
  // Auto-edit '??' keys and values.
  if (text == '??' && !this.alreadyFocused && this.doAutoFocus) {
    this.alreadyFocused = true;
    this.doAutoFocus = false;
    elem.click();
    jQuery(this).oneTime(100, function() { // Because JavaScript is annoying and we need to focus once the current stuff is done.
      elem.find('input').focus().select();
    });
  }
  return elem;
}

ParseletEditor.prototype.build = function(json, node, parent, key, root) {
  if(json instanceof Array){
    var bq = jQuery(document.createElement("BLOCKQUOTE"));
    bq.append(jQuery("<div>[</div>"));
    
    bq.prepend(this.addUI(json));
    if (parent) bq.prepend(this.deleteUI(key, parent));

    for(var i = 0; i < json.length; i++) {
      var innerbq = jQuery(document.createElement("BLOCKQUOTE"));
      this.build(json[i], innerbq, json, i, root);
      bq.append(innerbq);
    }
    
    bq.append(jQuery("<div>]</div>"));
    node.append(bq);
  } else if (json instanceof Object) {
    var bq = jQuery(document.createElement("BLOCKQUOTE"));
    bq.append(jQuery('<div>{</div>'));

    for(var i in json){
      var innerbq = jQuery(document.createElement("BLOCKQUOTE"));
      innerbq.append(this.editable(i.toString(), i.toString(), json, root, 'key').wrap('<span class="key"></b>').parent());
      if (typeof json[i] != 'string') {
        innerbq.prepend(this.braceUI(i, json));
        innerbq.prepend(this.bracketUI(i, json));
        innerbq.prepend(this.deleteUI(i, json, true));
      }
      innerbq.append(jQuery('<span class="colon">: </span>'));
      this.build(json[i], innerbq, json, i, root);
      bq.append(innerbq);
    }

    bq.prepend(this.addUI(json));
    if (parent) bq.prepend(this.deleteUI(key, parent));
    
    bq.append(jQuery('<div>}</div>'));
    node.append(bq);
  } else {
    node.append(this.editable(json.toString(), key, parent, root, 'value').wrap('<span class="val"></span>').parent());
    node.prepend(this.braceUI(key, parent));
    node.prepend(this.bracketUI(key, parent));
    if (parent) node.prepend(this.deleteUI(key, parent));
  }
};