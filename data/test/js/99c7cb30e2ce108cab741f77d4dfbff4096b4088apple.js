// ==========================================================================
// Project:   MyApp.appleController
// Copyright: ©2011 My Company, Inc.
// ==========================================================================
/*globals MyApp */

/** @class

  (Document Your Controller Here)

  @extends SC.ObjectController
*/
MyApp.appleController = SC.ObjectController.create(
/** @scope MyApp.appleController.prototype */ {
  contentBinding: SC.Binding.single('MyApp.applesController.selection')
}) ;

MyApp.colorController = SC.ObjectController.create({
  contentBinding: 'MyApp.appleController.color'
});

MyApp.shapeController = SC.ObjectController.create({
  contentBinding: 'MyApp.appleController.shape'
});

MyApp.tasteController = SC.ObjectController.create({
  contentBinding: 'MyApp.appleController.taste'
});

MyApp.applicantController = SC.ObjectController.create({
  contentBinding: 'MyApp.appleController.taste'
});

