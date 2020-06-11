/********************************
*This shows or hides the div's for the calculator
*based on the buttons displayed on the menu bar
*all divs are hidden then the apropriate div is shown
*It also checks if the calculator is hidden or shown and keeps
*it in whatever state the user had it
*********************************/


$('input:radio[name="category"]').change(
  function(){
    if ($(this).is(':checked')) {
      $('div').hide();//Notice that all divs are hidden
      var showCalc = $('#showCalc').html();//The inner html of the calculator is put in a variable as this represents the state the
                                           //calculator is in i.e. shown or hidding

      if(this.value === 'Columed'){//When the user presses one of the buttons its value is set coresponedingly i.e. columed, Google etc
        $('#show' + this.value).show();//The apropriate divs are then shown to the user
        $('.box3Col1').show();
        $('.box3Col2').show();
        $('.box3Col3').show();
        $('.smallBox').show();
        $('#barwrap').show();
        $('#topbar').show();
        $('#bottombar').show();
        $( '#contentwrap' ).show();
        $( '#timeBlock').show();
        $('#relatedSearch').show();
        $('#verticalPanel').show();
        if(showCalc == 'Hide Calculator'){//This shows the calculator check if the inner html of the show or hide button is hide
          $('#calbox').show();            //Then the callculator is shown (as that is its current state opposite to the word)
          $('#display').show();
          $('#prevsum').show();
          $('.row').show();
          $('.button').show();    
        }
      }
      else if(this.value === 'Google') {
        $('#show' + this.value).show();
        $('.googleBox').show();
        $('#barwrap').show();
        $('#topbar').show();
        $('#bottombar').show();
        $( '#contentwrap' ).show();
        $( '#timeBlock').show();
        $('#relatedSearch').show();
        $('#verticalPanel').show();
        if(showCalc == 'Hide Calculator'){
          $('#calbox').show();
          $('#display').show();
          $('#prevsum').show();
          $('.row').show();
          $('.button').show();    
        }
      }
      else if(this.value === 'Bing') {
        $('#show' + this.value).show();
        $('.bingBox').show();
        $('#barwrap').show();
        $('#topbar').show();
        $('#bottombar').show();
        $( '#contentwrap' ).show();
        $( '#timeBlock').show();
        $('#relatedSearch').show();
        $('#verticalPanel').show();
        if(showCalc == 'Hide Calculator'){
          $('#calbox').show();
          $('#display').show();
          $('#prevsum').show();
          $('.row').show();
          $('.button').show();    
        }
      }
      else if(this.value === 'Blekko') {
        $('#show' + this.value).show();
        $('.blekkoBox').show();
        $('#barwrap').show();
        $('#topbar').show();
        $('#bottombar').show();
        $( '#contentwrap' ).show();
        $( '#timeBlock').show();
        $('#relatedSearch').show();
        $('#verticalPanel').show();
        if(showCalc == 'Hide Calculator'){
          $('#calbox').show();
          $('#display').show();
          $('#prevsum').show();
          $('.row').show();
          $('.button').show();    
        }
      }
      else if(this.value === 'combMNZ') {
        $('#show' + this.value).show();
        $('.combMNZBox').show();
        $('#barwrap').show();
        $('#topbar').show();
        $('#bottombar').show();
        $( '#contentwrap' ).show();
        $( '#timeBlock').show();
        $('#relatedSearch').show();
        $('#verticalPanel').show();
        if(showCalc == 'Hide Calculator'){
          $('#calbox').show();
          $('#display').show();
          $('#prevsum').show();
          $('.row').show();
          $('.button').show();    
        }
      }
      else if(this.value === 'RRF') {
        $('#show' + this.value).show();
        $('.rrfBox').show();
        $('#barwrap').show();
        $('#topbar').show();
        $('#bottombar').show();
        $( '#contentwrap' ).show();
        $( '#timeBlock').show();
        $('#relatedSearch').show();
        $('#verticalPanel').show();
        if(showCalc == 'Hide Calculator'){
          $('#calbox').show();
          $('#display').show();
          $('#prevsum').show();
          $('.row').show();
          $('.button').show();    
        }
      }
      else if(this.value === 'Clustered') {
        $('#show' + this.value).show();
        $('#leftPanel').show();
        $('#eightTopics').show();
        $('#rightPanel').show();
        $('#cluster8').show();
        $('#cluster8Topic0').show();
        $('.resultClustBox').show();
        $('#barwrap').show();
        $('#topbar').show();
        $('#bottombar').show();
        $( '#contentwrap' ).show();
        $( '#timeBlock').show();
        $('#relatedSearch').show();
        $('#verticalPanel').show();
        if(showCalc == 'Hide Calculator'){
          $('#calbox').show();
          $('#display').show();
          $('#prevsum').show();
          $('.row').show();
          $('.button').show();    
        }

      }
  }
});