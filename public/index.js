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
    template_list.update_template_selector(after_type);
}

function get_current_type() {
    return document.main_form.output_type.value;
}

var template_list =
    (function() {
        // TODO: Exclusive updating for this list
        var list = null; // as JSON
        var updating_hooks = [];

        function append_template_option(selector, name) {
            var option = document.createElement('option');
            option.value = name;
            option.textContent = name;
            selector.appendChild(option);
        };

        function update_template_selector_impl(target) {
            if (list === null) {
                return;
            }
            var selector = document.querySelector('#template_selector');
            selector.textContent = null;
            append_template_option(selector, '');
            Array.prototype.forEach.call(list[target], function(name) {
                append_template_option(selector, name);
            });
        };

        function execute_updating_hooks() {
            for(var key in updating_hooks) {
                updating_hooks[key]();
            }
        };

        return {
            add: function(type, name) {
                if (list[type]) {
                    if (list[type].indexOf(name) >= 0) {
                        throw new Error("The name in the type is already registered: type, name = " +
                                        type + ", " + name);
                    }
                    list[type].push(name);
                }
                else {
                    list[type] = [name];
                }
                execute_updating_hooks();
            },
            delete: function(type, name) {
                if (!list[type]) {
                    throw new Error("The type is not exist: " + type);
                }
                var index = list[type].indexOf(name);
                if (index < 0) {
                    throw new Error("The name in the type has not been registered: type, name = " +
                                    type + ", " + name);
                }
                delete list[type][index];
                execute_updating_hooks();
            },
            get: function() {
                return list;
            },
            add_updating_hook: function(hook) {
                updating_hooks.push(hook);
            },
            update_template_selector: function(target) {
                if (list != null) {
                    update_template_selector_impl(target);
                }
                else {
                    request
                        .get('/templates/lists')
                        .end(function (err, res) {
                            if (err === null) {
                                list = JSON.parse(res.text);
                                update_template_selector_impl(target);
                            }
                        });
                }
            },
        }
    }());

template_list.add_updating_hook(function () {
    template_list.update_template_selector(get_current_type());
});

var template_manager =
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
                // TODO: Display yes-no dialog before execution
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
