// Document Ready
$(document).ready(function() {
  // Desired Services
  var desiredServices = ['apache2'
    ,'coldfusion_10'
    ,'mysql','mysqld'
    ,'grunt-watch-buildstore'
    ,'httpd'
    ,'postfix'
    ,'memcached'
  ];

  $.ajax('/ajax/serviceList', {
    success:function(services) {
      var targetServices= [];
      if (services) {
        for(var i=0; i<desiredServices.length; i++) {
          for(var j=0; j<services.length; j++) {
            if(desiredServices[i] === services[j]) {
              targetServices.push(services[j]);
              break;
            }
          }
        }
        createControls(targetServices);
      }
    }
  });

  function updateServiceStatusDisplay(service, data) {
    if (typeof data.running === 'undefined') {
      alert('doh!');
    } else {
      $('#service-'+service).toggleClass('running', data.running).toggleClass('stopped', !data.running);
    }
  }

  function serviceStarted(service, data) {
    appendToServiceConsole(data.output);
    serviceRequest(service, 'status', updateServiceStatusDisplay);
  }

  function serviceStopped(service, data) {
    appendToServiceConsole(data.output);
    serviceRequest(service, 'status', updateServiceStatusDisplay);
  }
  function serviceRestarted(service, data) {
    appendToServiceConsole(data.output);
    serviceRequest(service, 'status', updateServiceStatusDisplay);
  }

  function createControls(services) {
    $actionsList = $('ul.actions');
    // Create HTML elements for each service
    for (var i=0; i < services.length; i++) {
      var service = services[i];
      $actionsList.append('<li class="service-'+service+'" id="service-'+service+'"><img class="start" src="/asset/start.png" alt="Start" /><img class="stop" src="/asset/stop.png" alt="Stop" /><img class="restart" src="/asset/restart.png" alt="Restart" /><strong>'+service+'</strong></li>');

      $service = $actionsList.children('.service-'+service);
      serviceRequest(service, 'status', updateServiceStatusDisplay);
      $service.on('click', {service: service}, function(event) {
        $('#service-'+event.data.service).toggleClass('running', false).toggleClass('stopped', false);
        serviceRequest(event.data.service, 'status', updateServiceStatusDisplay);
      });
      $service.children('.start').on('click', {service: service}, function(event) {
        serviceRequest(event.data.service, 'start', serviceStarted);
      });
      $service.children('.stop').on('click', {service: service}, function(event) {
        serviceRequest(event.data.service, 'stop', serviceStopped);
      });
      $service.children('.restart').on('click', {service: service}, function(event) {
        serviceRequest(event.data.service, 'restart', serviceRestarted);
      });

      // Poll for status of each service periodically
      setInterval(function(service) {
        serviceRequest(service, 'status', updateServiceStatusDisplay);
      }, 5000, service);
    }
  }

  function serviceRequest(service, request, callback, failCallback) {
    $.ajax('/ajax/service/'+service+'/'+request, {
      success:function(data) {
        if (data.success) {
          callback(service, data);
        } else {
          if ( failCallback ) {
            failCallback(service, data);
          } else {
            appendToServiceConsole(data.output, true);
          }
        }
      }
    });
  }

  function appendToServiceConsole(text, error) {
    $('#services-console').append('<pre'+(error ? ' class="error"': '')+'>'+text+'</pre>');
    // Always scroll to bottom of #services-console
    $('#services-console').scrollTop($('#services-console')[0].scrollHeight);
  }
});