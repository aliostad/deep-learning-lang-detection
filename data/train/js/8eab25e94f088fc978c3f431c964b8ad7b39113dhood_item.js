Session.set('showAlertAdd', false);
Session.set('showDummy', false);
Template.hoodItem.helpers({
	showAdd: function(){
		return Session.get('showAlertAdd');
	},
	showDummy: function(){
		return Session.get('showDummy');
	}
});

Template.hoodItem.events({
	'click .addAlert': function(e){
		e.preventDefault();
		if(Session.get('showAlertAdd')){
			Session.set('showAlertAdd', false);
		}else{
			Session.set('showAlertAdd', true);
		}
	},
	'click .dummyShow': function(e){
		e.preventDefault();
		if(Session.get('showDummy')){
			Session.set('showDummy', false);
		}else{
			Session.set('showDummy', true);
		}
	}
});