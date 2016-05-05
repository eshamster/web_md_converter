var reporter =
    (function() {
      function get_reporter() {
        return document.querySelector('#reporter')
      }

      function report(target_class, message) {
        var reporter = get_reporter();
        reporter.className = target_class;
        reporter.innerHTML = message;
      }
      
      return {
        fatal: function(message) {
          alert(message);
        },
        error: function(message) {
          report('error', message);
        },
        notice: function(message) {
          report('notice', message);
        }
      }
    }());
