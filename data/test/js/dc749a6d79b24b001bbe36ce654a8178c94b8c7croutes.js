Router.route('/', {
  name: 'home',
  controller:'HomeController'
});

Router.route('/dashboard', {
  name: 'dashboard',
  controller: 'DashboardController'
});

Router.route('/info',{
  name:'info'
});



Router.route('editProfile',{
    path:'/edit_profile/:id',
    controller: 'EditProfileController'

});

Router.route('Profile',{
    path:'/profile/:id',
    controller: 'ProfileController'

});



Router.route('upload',{
    path:'/conference-detail/:_id/upload',
    controller:'uploadController'

});

Router.route('mun',{
    path:'/conference/:op',
    controller:"ConferenceController",
});

Router.route('confDetail',{
    path:'/conference-detail/:conf_name',
    controller:"ConfDetailController"
});

Router.route('confOrganize',{
    path:'/conference/:_id/organize',
    controller:"DashboardOrgnController",
});

Router.route('confReg',{
    path:'/conference/:conf_name/register',
    controller:"ConferenceRegController"
});



