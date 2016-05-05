var request = window.superagent;

function foreach_selector(selector, func) {
  var elems = document.querySelectorAll(selector);
  Array.prototype.forEach.call(elems, function(elem) {
    func(elem);
  });
}

function hide_all_conf () {
  foreach_selector('[class*="conf"]', function(conf) {
    conf.style.display = 'none';
  });
}

function show_one_conf_only (target_type) {
  hide_all_conf();
  foreach_selector('.' + target_type + '_conf', function(conf) {
    conf.style.display = '';
  });
}

function do_after_switch_type (after_type) {
  show_one_conf_only(after_type);
  template_selector.update(after_type);
}

function get_current_type() {
  return document.main_form.output_type.value;
}

function check_convert_form(form) {
  if (form.file.files.length == 0) {
    tools.report_error("Please select a markdown file");
    return false;
  }
  return true;
}

var template_selector =
    (function() {
      function append_option_to_selector(selector, name) {
        var option = document.createElement('option');
        option.value = name;
        option.textContent = name;
        selector.appendChild(option);
      };

      return {
        update: function(target) {
          var list = template_list.get(target);
          if (list === null) {
            return;
          }
          var selector = document.querySelector('#template_selector');
          selector.textContent = null;
          append_option_to_selector(selector, '');
          Array.prototype.forEach.call(list, function(name) {
            append_option_to_selector(selector, name);
          });
        }
      };
    }());

var template_list =
    (function() {
      // TODO: Exclusive updating for this list
      var list = null; // as JSON
      var updating_hooks = [];

      function execute_updating_hooks() {
        for(var key in updating_hooks) {
          updating_hooks[key]();
        }
      };

      function get_type_array(type) {
        if (!list[type]) {
          throw new Error("The type is not exist: " + type);
        }
        return list[type].list
      };

      return {
        add: function(type, name) {
          var array = get_type_array(type);
          if (array.indexOf(name) >= 0) {
            throw new Error("The name in the type is already registered: type, name = " +
                            type + ", " + name);
          }
          array.push(name);
          execute_updating_hooks();
        },
        delete: function(type, name) {
          if (!list[type]) {
            throw new Error("The type is not exist: " + type);
          }
          var array = get_type_array(type)
          var index = array.indexOf(name);
          if (index < 0) {
            throw new Error("The name in the type has not been registered: type, name = " +
                            type + ", " + name);
          }
          delete array[index];
          execute_updating_hooks();
        },
        get: function(type) {
          return get_type_array(type);
        },
        add_updating_hook: function(hook) {
          updating_hooks.push(hook);
        },
        init: function() {
          request
            .get('/templates/lists')
            .end(function (err, res) {
              if (err === null) {
                list = JSON.parse(res.text);
                execute_updating_hooks();
              }
              else {
                alert("Error in initializing template_list: " + err.message)
              }
            });
        }
      }
    }());

template_list.add_updating_hook(function () {
  template_selector.update(get_current_type());
});

var template_ajax =
    (function() {
      return {
        get: function(type, name) {
          try {
            var form = document.template_get_form;
            form.type.value = type;
            form.name.value = name;
            form.submit();
          }
          finally {
            // This function is assumed to be called in another form
            // not in template_get_form. So it is needed to prevent
            // executing submitting in the former form
            return false;
          }
        },
        post: function() {
          try {
            var form = document.template_post_form; 
            var main_form = document.main_form;
            request
              .post('/templates')
              .attach('file', form.file.files[0])
              .field('type', main_form.output_type.value)
              .field('name', form.file.value.split(/[\/\\]/).pop())
              .end(function (err, res) {
                if (err === null) {
                  var res_json = JSON.parse(res.text);
                  template_list.add(res_json.type, res_json.name);
                  alert("Uploaded successfully!!\n" +
                        "type: " + res_json.type + "\n" +
                        "name: " + res_json.name);
                }
                else {
                  alert(err.response.text);
                }
              });
          }
          finally {
            return false;
          }
        },
        delete: function() {
          try {
            if (!window.confirm("Are you sure want to delete the template?")) {
              return;
            }
            var main_form = document.main_form;
            var type = main_form.output_type.value;
            var name = main_form.template.value;
            request.del('/templates')
              .field('name', name)
              .field('type', type)
              .end(function (err, res) {
                if (err === null) {
                  var res_json = JSON.parse(res.text);
                  template_list.delete(res_json.type, res_json.name);
                  alert("Deleted successfully!!\n" +
                        "type: " + res_json.type + "\n" +
                        "name: " + res_json.name);
                }
                else {
                  alert(err.response.text);
                }
              });
          }
          finally {
            return false;
          }
        }
      }
    }());
