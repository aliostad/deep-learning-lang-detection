function showGender(data){
  if(data=='3'){
    $('.gendergrey').hide();
    $('.gendercolour').hide();
    $('#mengrey').show();
    $('#womengrey').show();
    $('#anyonecolour').show();
    $('#gendervalue').val('all');
    $('#gender').val('3');
  }else if(data=='1'){
    $('.gendergrey').hide();
    $('.gendercolour').hide();
    $('#anyonegrey').show();
    $('#womengrey').show();
    $('#mencolour').show();
    $('#gendervalue').val('men');
    $('#gender').val('1');
  }else if(data=='2'){
    $('.gendergrey').hide();
    $('.gendercolour').hide();
    $('#anyonegrey').show();
    $('#mengrey').show();
    $('#womencolour').show();
    $('#gendervalue').val('women');
    $('#gender').val('2');
  }
}

function showPeople(data){
  if(data=='0'){
    
    $('#coffeegrey').hide();

    $('#lunchcolour').hide();
    $('#dinnercolour').hide();

    $('#lunchgrey').show();
    $('#dinnergrey').show();

    $('#invitepeoplevalue').val('coffee');
    $('#invitepeople').val('0');
    
    $('#coffeecolour').show();
  }else if(data=='1'){
   
    $('#lunchgrey').hide();
    $('#dinnercolour').hide(); 
    $('#coffeecolour').hide();


    $('#dinnergrey').show();

    $('#coffeegrey').show();
    
    $('#invitepeoplevalue').val('lunch');
    $('#invitepeople').val('1');

    $('#lunchcolour').show();

  }else if(data=='2'){
    $('#lunchcolour').hide();
    $('#coffeecolour').hide();
    $('#dinnergrey').hide();

    $('#coffeegrey').show();
    $('#lunchgrey').show();

    $('#invitepeoplevalue').val('dinner');
    $('#invitepeople').val('2');
    $('#dinnercolour').show();
  }
}