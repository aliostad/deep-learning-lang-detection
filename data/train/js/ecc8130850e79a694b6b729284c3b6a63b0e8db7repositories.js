import Ember from "ember";

export default Ember.ArrayController.extend({
    showAll: false,
    showRepositories: 'Show Repositories',
    actions: {
        toggleRepositories: function(){
            if(this.get('showAll')){
                this.set('showAll', false);
                this.set('showRepositories', 'Show Repositories');
            }
            else{
                this.set('showAll', true);
                this.set('showRepositories', 'Hide Repositories');
            }
        }
    }
});