var Form = fw.create([BaseWidget],{

	bind:function(){
		this.$super();
		this.setControllerInstance(searchController(this.getController(),this.getPage()));
	},
	
	 
	
	setControllerInstance:function(controllerInstance){
		this.controllerInstance = controllerInstance;
		controllerInstance.addForm(this);
	},
	
	
	
  setController:function(controller){
	  this.controller = controller;
  },
  
  getController:function(){
	  return this.controller;
  },

  setTitle : function(title){
	  this.title = title;
  },
  
  getTitle : function(){
	  return this.title;
  }  
   
});