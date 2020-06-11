Ext.define('Follower.controller.Show', {
    extend: 'Ext.app.Controller',
    
    models: ['Show'],
    
    init: function() {
        // this.control({
        //     'show-info': {
        //         load: this.loadShow
        //     }
        // });
    }
    
    // loadShow: function(panel, showId) {
    //     // panel.setLoading(true);
    //     // this.getShowModel().load(showId, {
    //     //     callback: function(info) {
    //     //         panel.update(info.data);
    //     //         panel.setLoading(false);
    //     //     }
    //     // });
    // }
});