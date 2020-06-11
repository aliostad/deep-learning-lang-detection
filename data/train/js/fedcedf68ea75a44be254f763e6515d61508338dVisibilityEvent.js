/**
 * @class Teselagen.event.VisibilityEvent
 * Events for when VE view options are changed.
 * @author Nick Elsbree
 */
Ext.define("Teselagen.event.VisibilityEvent", {
    singleton: true,
    
    SHOW_FEATURES_CHANGED: "ShowFeaturesChanged",
    SHOW_CUTSITES_CHANGED: "ShowCutSitesChanged",
    SHOW_ORFS_CHANGED: "ShowOrfsChanged",
    SHOW_COMPLEMENTARY_CHANGED: "ShowComplementaryChanged",
    SHOW_SPACES_CHANGED: "ShowSpacesChanged",
    SHOW_SEQUENCE_AA_CHANGED: "ShowSequenceAAChanged",
    SHOW_REVCOM_AA_CHANGED: "ShowRevcomAAChanged",
    SHOW_FEATURE_LABELS_CHANGED: "ShowFeatureLabelsChanged",
    SHOW_CUTSITE_LABELS_CHANGED: "ShowCutSiteLabelsChanged",
    SHOW_MAP_CARET_CHANGED: "ShowMapCaretChanged",

    // View mode changes from pie <-> rail.
    VIEW_MODE_CHANGED: "ViewModeChanged",
});
