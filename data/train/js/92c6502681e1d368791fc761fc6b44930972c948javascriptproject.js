$(".poetry").click(function () {
  $(".abcedarian").show();
  $(".latrappiste").show();
  $(".muertos").show();
  $(".ekphrastic").show();
  $(".dianahunter").hide();
  $(".minime").hide();
  $(".fiction").show();
});

$(".poetry").click(function(){
  $(".fiction").animate(
    {
      'margin-left':'700px'
    },0);
});

$(".fiction").click(function(){
  $(".abcedarian").hide();
  $(".latrappiste").hide();
  $(".muertos").hide();
  $(".ekphrastic").hide();
  $(".poetry").show();
  $(".dianahunter").show();
  $(".minime").show();
})

$(".fiction").click(function(){
  $(".fiction").animate(
    {
      'margin-left':'700px'
    },0);
});
