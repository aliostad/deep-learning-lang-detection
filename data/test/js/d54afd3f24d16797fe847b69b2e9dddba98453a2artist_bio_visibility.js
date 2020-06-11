var app = require('app');

module.exports = Backbone.Marionette.ItemView.extend({
    
	events: {
		'click button': 'showMoreClicked'
    },

    template: require('templates/music/artist_bio_visibility'),

    showMoreClicked: function(e) {

        var buttonText;

        if (this.showMore) {
            buttonText = 'Show More';
            this.showMore = false;
        } else {
            buttonText = 'Show Less';
            this.showMore = true;
        }

        this.$('button').text(buttonText);

        this.trigger('show-more');
    }
    
});