define(['base','./header_controller','./landing_controller','./forms_controller','./footer_controller','../main/view'],
    function(Base,HeaderController,LandingController,FormsController,FooterController,MainView){
  return Base.Controller.extend({
    name : 'main',
    initialize : function(){
      new HeaderController({ $el : _.bind(this.$el.find,this.$el,'.main-header') });
      new LandingController({ $el : _.bind(this.$el.find,this.$el,'.content') });
      new FormsController({ $el : _.bind(this.$el.find,this.$el,'.content') });
      new FooterController({ $el : _.bind(this.$el.find,this.$el,'.footer') });
    },
    index : function(){
      return new MainView();
    },
  });
});
