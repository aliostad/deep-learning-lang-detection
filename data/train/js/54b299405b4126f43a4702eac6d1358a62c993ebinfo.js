$(function () {
    switch (actionUrl) {
      case 'about' :
        $('.leftFloatNav .navList>li:eq(0)').addClass("active")
        break;
      case 'cert' :
        $('.leftFloatNav .navList>li:eq(1)').addClass("active")
        break;
      case 'contact' :
        $('.leftFloatNav .navList>li:eq(2)').addClass("active")
        break;
      case 'cost' :
        $('.leftFloatNav .navList>li:eq(3)').addClass("active")
        break;
      case 'notice' :
        $('.leftFloatNav .navList>li:eq(4)').addClass("active")
        break;
      case 'trend' :
        $('.leftFloatNav .navList>li:eq(5)').addClass("active")
        break;
      case 'mode' :
        $('.leftFloatNav .navList>li:eq(6)').addClass("active")
        break;
      case 'safe' :
        $('.leftFloatNav .navList>li:eq(7)').addClass("active")
        break;
      default :
        break;
    }
})
