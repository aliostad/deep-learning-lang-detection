(function(){
  'use strict';

  $(document).ready(init);

  function init(){
    $('#accounts').hide();
    $('#recipes').hide();
    $('#showRecipes').click(showRecipes);
    $('#showAccounts').click(showAccounts);
    $('#showProfile').click(showProfile);

  }

  function showRecipes(){
    $('#profile').hide();
    $('#accounts').hide();
    $('#recipes').show();
  }

  function showAccounts(){
    $('#profile').hide();
    $('#accounts').show();
    $('#recipes').hide();
  }

  function showProfile(){
    $('#profile').show();
    $('#accounts').hide();
    $('#recipes').hide();
  }



})();
