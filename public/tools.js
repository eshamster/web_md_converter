var reporter =
    (function() {
      return {
        fatal: function(message) {
          alert(message);
        }
        error: function(message) {
          alert(message);
        }
        notice: function(message) {
          alert(message);
        }
      }
    }());
