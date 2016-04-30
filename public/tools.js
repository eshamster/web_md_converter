var ajax =
    (function() {
        return {
            send: function(method, url, success, failure) {
                var xhr = new XMLHttpRequest();
                xhr.open(method, url, true);
                xhr.send();
                xhr.onreadystatechange = function(e) {
                    if (xhr.readyState == 4 && xhr.status == 200) {
                        success(xhr);
                    }
                    else if (failure) {
                        failure(xhr.readyState, xhr.status, e)
                    }
                }
            }
        };}())
