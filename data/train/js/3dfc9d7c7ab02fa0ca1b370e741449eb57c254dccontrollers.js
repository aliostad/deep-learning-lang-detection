(function(){
  'use strict';
  
  angular
    .module('app')
    .controller('Body_Controller', Body_Controller)
    .controller('Partials_A_Controller', Partials_A_Controller)
    .controller('Partials_B_Controller', Partials_B_Controller)
    .controller('Partials_C_Controller', Partials_C_Controller)
    ;

  /* @ngInject */
  function Body_Controller($log){
    $log.log('Body_Controller loaded.');
  }

  /* @ngInject */
  function Partials_A_Controller($log){
    var pc = this;
    
    pc.type = 'crisp';
    
    $log.log('Partials_A_Controller loaded.', pc);
  }

  /* @ngInject */
  function Partials_B_Controller($log){
    var pc = this;
    
    pc.type = 'pudding';
    
    $log.log('Partials_B_Controller loaded.', pc);
  }

  /* @ngInject */
  function Partials_C_Controller($log){
    var pc = this;
    
    pc.type = 'pie';
    
    $log.log('Partials_C_Controller loaded.', pc);
  }
})();