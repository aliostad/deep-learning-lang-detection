/**
 * Created on 2015/01/20.
 */
var UNIVERSALVIEWER = UNIVERSALVIEWER || {};
UNIVERSALVIEWER.Service = UNIVERSALVIEWER.Service || {};
UNIVERSALVIEWER.Service.Viewer = UNIVERSALVIEWER.Service.Viewer || {};

UNIVERSALVIEWER.Service.Viewer.app = angular.module('universalViewer.services', ['ngResource', 'common.services']);

UNIVERSALVIEWER.Service.Viewer.app.service('homeViewService', ['sharedStoreService', 'searchService', UNIVERSALVIEWER.Service.Viewer.HomeViewClass]);
UNIVERSALVIEWER.Service.Viewer.app.service('binderViewService', ['sharedStoreService', 'searchService', UNIVERSALVIEWER.Service.Viewer.BinderViewClass]);
UNIVERSALVIEWER.Service.Viewer.app.service('originalPageViewService', ['sharedStoreService', 'searchService',UNIVERSALVIEWER.Service.Viewer.OriginalPageViewClass]);
UNIVERSALVIEWER.Service.Viewer.app.service('originalPageDetailViewService', ['sharedStoreService', 'searchService',UNIVERSALVIEWER.Service.Viewer.OriginalPageDetailViewClass]);
UNIVERSALVIEWER.Service.Viewer.app.service('binderPageViewService', ['sharedStoreService', 'searchService',UNIVERSALVIEWER.Service.Viewer.BinderPageViewClass]);
UNIVERSALVIEWER.Service.Viewer.app.service('binderPageDetailViewService', ['sharedStoreService', 'searchService',UNIVERSALVIEWER.Service.Viewer.BinderPageDetailViewClass]);
UNIVERSALVIEWER.Service.Viewer.app.service('timelineViewService', ['sharedStoreService', 'searchService',UNIVERSALVIEWER.Service.Viewer.TimelineViewClass]);

