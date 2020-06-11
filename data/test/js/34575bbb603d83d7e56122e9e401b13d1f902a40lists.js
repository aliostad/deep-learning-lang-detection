$(document).ready(function(){

  var controller = ".lists-controller";
  var wordName = controller + " #word-name";
  var showHint = controller + " #show-hint";
  var showMeaning = controller + " #show-meaning";
  var wordMeaning = controller + " #word-meaning";
  var wordSentence = controller + " #word-sentence";

  $(showHint + '.test').show();
  $(showHint + '.learn').hide();
  $(showHint).css({'cursor': 'pointer'})
  $(showHint).click(function() { 
    $(wordSentence).show();
    $(showHint).hide();
  });

$(showMeaning + '.test').show();
$(showMeaning + '.learn').hide();
$(showMeaning).css({'cursor': 'pointer'})
  $(showMeaning).click(function() {  
    $(wordMeaning).show();
    $(wordSentence).show();
    $(showMeaning).hide();
    $(showHint).hide();
  });

$(wordMeaning + '.test').hide();
$(wordMeaning + '.learn').show();

$(wordSentence + '.test').hide();
$(wordSentence + '.learn').show();

});

