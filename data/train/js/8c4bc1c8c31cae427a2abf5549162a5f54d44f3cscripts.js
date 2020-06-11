(function(){
  var jobHandler = document.getElementById("jobs");

  var $jobForm = $("form"),
      $measurements = $(".dnc"),
      $filemp3 = $("#filemp3"),
      $filemp4 = $("#filemp4"),
      $website = $("#website");

  $jobForm.hide();

  function jobSelection(){
    jobHandler.onchange = function(){
      var selectedJob = jobHandler.selectedIndex;

      switch(selectedJob){
        case 1:
          console.log("Dancers");
          $jobForm.show();
          $measurements.show();
          $filemp3.show();
          $filemp4.show();
          $website.show();
          break;
        case 2:
          console.log("DJ");
          $jobForm.show();
          $measurements.hide();
          $filemp3.show();
          $filemp4.show();
          $website.show();
          break;
        case 3:
          console.log("Band");
          $jobForm.show();
          $measurements.hide();
          $filemp3.show();
          $filemp4.show();
          $website.show();
          break;
        case 4:
          console.log("Illusionist");
          $jobForm.show();
          $measurements.hide();
          $filemp3.show();
          $filemp4.show();
          $website.show();
          break;
        case 5:
          console.log("Other");
          $jobForm.show();
          $measurements.hide();
          $filemp3.show();
          $filemp4.show();
          $website.show();
          break;
        default:
          $jobForm.hide();
      }
    };
  }

  $(function(){
    
    jobSelection();
    // console.log("jquery loaded OK!");
      
  });
}());