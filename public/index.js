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
    template.update_template_selector(after_type);
}

var template_manager =
    (function() {
        var templates_list = null; // as json

        function append_template_option(selector, name) {
            var option = document.createElement('option');
            option.value = name;
            option.textContent = name;
            selector.appendChild(option);
        };

        function update_template_selector_impl(target) {
            if (templates_list === null) {
                return;
            }
            var selector = document.querySelector('#template_selector');
            selector.textContent = null;
            append_template_option(selector, '');
            Array.prototype.forEach.call(templates_list[target], function(name) {
                append_template_option(selector, name);
            });
        };

        return {
            // TODO: avoid duplicated GET request when this is called in many times at short intervals
            update_template_selector: function(target) {
                if (templates_list != null) {
                    update_template_selector_impl(target);
                }
                else {
                    request
                        .get('/templates/lists')
                        .end(function (err, res) {
                            if (err === null) {
                                templates_list = JSON.parse(res.text);
                                update_template_selector_impl(target);
                            }
                        });
                }
            },
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
                                alert("Deleted successfully!!\n" +
                                      "type: " + res_json['type'] + "\n" +
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
