$(document).ready(function() {
  $('.2Partition').hide();
  $('.3Partition').hide();
  $('.4Partition').hide();
  $('.6Partition').hide();
  $('.12Partition').hide();
});

function showThings(part){
    switch(part){ 
      case 2 :
        $('.2Partition').show();
        break;
      case 3 :
        $('.3Partition').show();
        break;
      case 4 :
        $('.4Partition').show();
        break;
      case 6 :
        $('.6Partition').show();
        break;
      case 12 :
        $('.12Partition').show();
        break;
    }
  }