define([//'jquery', 
        'underscore', 'backbone','text!page/05-1-1_myPage.html',
        'mec/model/myPageModel'
        ], 
function(//$, 
		_, Backbone, mainView,mainModel){

  return cpmView = Backbone.View.extend({
	  
    template:_.template(mainView),
   
    initialize : function() {
    	
    },
    
    refresh: function(){
    	
    },
    
    render: function(){
      $(this.el).empty();
      $(this.el).html(this.template(this.model.toJSON()));
      return this;
    },
    
    events: {
        'click .myproperty':'showMypropertyPage',
        'click .myorder':'showMyorderPage',
        'click .mymessage':'showMymessagePage',
        'click .mysetting':'showMysettingPage',
        //'click .advice':'showAdvicePage',
        'click .update':'showUpdatePage'
        //'click .aboutus':'showAboutusPage'
    },
      showMypropertyPage:function(){
          window.AppRouter.showMypropertyPage();
      },
      showMyorderPage:function(){
          window.AppRouter.showMyorderPage();
      },
      showMymessagePage:function(){
          window.AppRouter.showMymessagePage();
      },
      showMysettingPage:function(){
          window.AppRouter.showMysettingPage();
      },
      //showAdvicePage:function(){
      //    window.AppRouter.showAdvicePage();
      //},
      showUpdatePage:function(){
          window.AppRouter.showUpdatePage();
      }
      //showAboutusPage:function(){
      //    window.AppRouter.showAboutusPage();
      //},
  });
});