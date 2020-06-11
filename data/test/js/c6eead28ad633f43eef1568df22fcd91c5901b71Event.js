/**
 * The authentication event contains data and event types to login/out the user.
 */
Ext.define("Core.event.navigation.Event", {
    extend: "FlowMVC.mvc.event.AbstractEvent",

    statics: {
        NAVIGATE:                           "navigate",

        RIGHT:                              "navigateRight",
        LEFT:                               "navigateLeft",
        
		// CAN WE MOVE THIS BELOW AWAY... IT SHOULDN'T BE PART OF NAVIGATE
		// ... STILL TO DO..FOR NOW navigate NEEDS IT HERE
		
		ACTION_BACK_SHOW_PERSON_LIST:     	"actionBackShowPersonList",
        ACTION_BACK_SHOW_PERSON_TILE:     	"actionBackShowPersonTile",
        ACTION_SHOW_PERSON_DETAIL:        	"actionShowPersonDetail",  
        ACTION_SHOW_PERSON_MODAL:         	"actionShowPersonModal",
		
		ACTION_BACK_SHOW_ORGANISATION_LIST: "actionBackShowOrganisationList",
        ACTION_BACK_SHOW_ORGANISATION_TILE: "actionBackShowOrganisationTile",
        ACTION_SHOW_ORGANISATION_DETAIL:    "actionShowOrganisationDetail",  
        ACTION_SHOW_ORGANISATION_MODAL:     "actionShowOrganisationModal",
		
		ACTION_BACK_SHOW_PRODUCT_LIST: 		"actionBackShowProductList",
        ACTION_BACK_SHOW_PRODUCT_TILE: 		"actionBackShowProductTile",
        ACTION_SHOW_PRODUCT_DETAIL:    		"actionShowProductDetail",  
        ACTION_SHOW_PRODUCT_MODAL:     		"actionShowProductModal",

		ACTION_BACK_SHOW_BOOKING_LIST: 		"actionBackShowBookingList",
        ACTION_BACK_SHOW_BOOKING_TILE: 		"actionBackShowBookingTile",
        ACTION_SHOW_BOOKING_DETAIL:    		"actionShowBookingDetail",  
        ACTION_SHOW_BOOKING_MODAL:     		"actionShowBookingModal",

		ACTION_BACK_SHOW_EVENT_LIST: 		"actionBackShowEventList",
        ACTION_BACK_SHOW_EVENT_TILE: 		"actionBackShowEventTile",
        ACTION_SHOW_EVENT_DETAIL:    		"actionShowEventDetail",  
        ACTION_SHOW_EVENT_MODAL:     		"actionShowEventModal",
		
		ACTION_BACK_SHOW_ASSET_LIST: 		"actionBackShowAssetList",
        ACTION_BACK_SHOW_ASSET_TILE: 		"actionBackShowAssetTile",
        ACTION_SHOW_ASSET_DETAIL:    		"actionShowAssetDetail",  
        ACTION_SHOW_ASSET_MODAL:     		"actionShowAssetModal",
		
		ACTION_BACK_SHOW_INDIVIDUAL_LIST:	"actionBackShowIndividualList",
        ACTION_BACK_SHOW_INDIVIDUAL_TILE:	"actionBackShowIndividualTile",
        ACTION_SHOW_INDIVIDUAL_DETAIL:		"actionShowIndividualDetail",  
        ACTION_SHOW_INDIVIDUAL_MODAL:		"actionShowIndividualModal"		
		
    },

    action: "",
    direction: "",

    /**
     * Constructor. Provides details on how the application should navigate and to what screen.
     *
     * @param {String} type The event type.
     * @param {String} action The string action that maps to the navigation.
     * @param {String} direction An optional direction property for navigation.
     */
    constructor: function(type, action, direction) {
        this.callParent(arguments);

        this.action = action;
        this.direction = direction;
    }
});