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
        xhr.open('GET', '/templates', true);
        xhr.send();
        xhr.onreadystatechange = function(e) { 
            if (xhr.readyState == 4 && xhr.status == 200) {
                templates_list = JSON.parse(xhr.responseText); 
            }
            update_template_selector_impl(target);
        }
    }
}
