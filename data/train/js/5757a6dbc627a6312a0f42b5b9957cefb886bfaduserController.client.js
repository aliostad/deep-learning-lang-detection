(function () {
   var navAvatar = $("#avatar-sm") || null;
   var navUnauth = $(".unauth") || null;
   var navAuth = $(".auth") || null;
   var navUser = $("#nav-user") || null;
   var apiUrl = appUrl + '/api/:id';

   navUnauth.each(function(a) { $(navUnauth[a]).css("display", "block") });
   navAuth.each(function(a) { $(navAuth[a]).css("display", "none") });
   ajaxFunctions.ready(ajaxFunctions.ajaxRequest('GET', apiUrl, function (data) {
      var userObject = JSON.parse(data);
      if (navAvatar) $(navAvatar).prop("src", userObject.profile.picture);
      if (userObject.profile.name) {
        $(navUser).html($(navUser).html() + userObject.profile.name);
        navUnauth.each(function(a) { $(navUnauth[a]).css("display", "none") });
        navAuth.each(function(a) { $(navAuth[a]).css("display", "block") });
      }
   }));
})();
