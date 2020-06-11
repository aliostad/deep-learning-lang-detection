/**
 * Base interface for showing error/warning/success message 
 */
define(['jquery'], function($) {
  /**
    * @params message(String), the message you want to show.
    * @params type(String), values: 'danger', 'success', 'error', or user defined.
    * @params refresh(boolean), please set it true, if you want to show this message after freshing page.
    * @params time(int), how long you want to show this message, default value is 4000ms. 
    */
  function _message(message, type, refresh, time) {
    var _time = 4000;
    var fadeTime = 500;
    time = (undefined === time) ? _time : time;
    message = $.trim(message);
    var $messageNode = $('.alert_message');
    var $messageText = $messageNode.find('span');
    var $closeBtn = $messageNode.find('.close');

    if ((false === refresh) || (undefined === refresh)) {
      $closeBtn.on('click', function() {
        $messageNode.addClass('hide');
      });
      $messageText.text(message);
      type = 'alert-' + type;

      $messageNode.fadeIn(fadeTime, function() {
        $messageNode.addClass(type).removeClass('hide');
        window.setTimeout(function() {
          $messageNode.fadeOut(fadeTime, function() {
            $messageNode.addClass('hide').removeClass(type);
          });
        }, time);
      });
    } else {
      if (message) {
        var messageObj = {
          'message': message,
          'type': type,
          'time': time
        };
        window.sessionStorage.setItem('alertMessage', JSON.stringify(messageObj));
      }
    }
  };
  
  return {
    message: _message,
    error: function(message, refresh) {
      this.message(message, 'danger', refresh);
    },
    success: function(message, refresh) {
      this.message(message, 'success', refresh);
    },
    info: function(message, refresh) {
      this.message(message, 'info', refresh);
    },
    initAlertMessage: function() {
      var alertMessage = JSON.parse(window.sessionStorage.getItem('alertMessage'));
        if ((null !== alertMessage) && ('' !== alertMessage)) {
          msg.message(alertMessage.message, alertMessage.type, false, alertMessage.time);
          window.sessionStorage.removeItem('alertMessage');
        }
    }
  };
});