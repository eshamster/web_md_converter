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
    update_template_selector(after_type);
}

var templates_list = null; // as json

function append_template_option(selector, name) {
    var option = document.createElement('option');
    option.value = name;
    option.textContent = name;
    selector.appendChild(option);
}

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
}

// TODO: avoid duplicated GET request when this is called in many times at short intervals
function update_template_selector(target) {
    if (templates_list != null) {
        update_template_selector_impl(target);
    }
    else {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', '/templates/lists', true);
        xhr.send();
        xhr.onreadystatechange = function(e) { 
            if (xhr.readyState == 4 && xhr.status == 200) {
                templates_list = JSON.parse(xhr.responseText); 
            }
            update_template_selector_impl(target);
        }
    }
}

function get_template(type, name) {
    try {
        var form = document.template_get_form;
        form.type.value = type;
        form.name.value = name;
        form.submit();
    }
    finally {
        // This function is assumed to be called in another form not in template_get_form.
        // So it is needed to prevent executing submitting in the former form
        return false;
    }
}

function post_template() {
    try {
        var form = document.template_post_form;
        var main_form = document.main_form;
        form.type.value = main_form.output_type.value;
        form.name.value = form.file.value.split(/[\/\\]/).pop();
    }
    finally {
        return false;
    }
}
