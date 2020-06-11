/**
 * @class Teselagen.event.VisibilityEvent
 * This class defines events for when the visibility of a certain annotation type
 * changes.
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
    SHOW_CUTSITE_LABELS_CHANGED: "ShowCutSiteLabelsChanged"
});
