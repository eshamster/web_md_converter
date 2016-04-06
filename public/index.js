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

function show_one_conf_only (elem) {
    hide_all_conf();
    foreach_selector('.' + elem.value + '_conf', function(conf) {
        conf.style.display = '';
    });
}
