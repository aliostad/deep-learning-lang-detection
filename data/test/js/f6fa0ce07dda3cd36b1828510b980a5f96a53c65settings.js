/**
 *
 *
 */

var vis = {},
    cat = 'Major Sector'
    ;

var setting = {
    childLife : 0 // number of steps of life a child
    , parentLife : 0 // number of steps of life a parent
    , showCountExt : true // show table of child's extension
    , onlyShownExt : true // show only extension which is shown
    , showHistogram : true // displaying histogram of changed files
    , showHalo : true // show a child's halo
    , padding : 0 // padding around a parent
    , rateOpacity : .5 // rate of decrease of opacity
    , rateFlash : 2.5 // rate of decrease of flash
    , sizeChild : 2 // size of child
    , sizeParent : 5 // size of parent
    , showPaddingCircle : false // show circle of padding
    , useImage : true // show base's image
    , showChild : true // show a child
    , showParent : false // show a parent
    , showLabel : false // show base name
    , showMessage : false // show commit message
    , skipEmptyDate : true // skip empty date
    , blendingLighter : true
    , showTrack : true // show tracks
    , showEdge : false // show an edge
    , groupByRegion : false
    , fadingTail : true
};

var ONE_SECOND = 1000,
    stepDate = 24 * 60 * 60 * 1000
	;
