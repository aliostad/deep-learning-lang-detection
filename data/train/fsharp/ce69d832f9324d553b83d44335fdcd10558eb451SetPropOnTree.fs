//	clearAppCritiche.fs
//
//	VERSION INFORMATION
//		Version: 1.01
//
//		2005May03 - 1.00 Created by The Unknown Scripter
//		2006Sep07 - 1.01 Comments and cleanup - Ray Parker
//
//
//	Purpose
//		Filter elements based on class, set a property on filtered elements
//
//	Notes
//		none
//
//	Required Changes
//		none
//
//	Optional Changes
//
//	Implementation
//		1) 
//
/*

[Structure|Tree|Set Algorithm on element by class]
command=
context=element
description=Tree|Set Algorithm on element by class
operation=load('custom/operation/SetPropOnTree');
permission=manage
target=dname:root=Organizations
type=serverscript

 */

// closure
(function () {
	load('custom/lib/underscore.js');
	
	var classList = ['Provincia'];
	var propNames = ['Algorithm'];
	var propValues = ['provinciaOnAgenzie'];
	var visitor =
	{
		count: 0,
		visit: function ( child ) {
			var clazz = child.elementClassname + '';
			if (_.contains(classList, clazz)) {
				for (idx = 0; idx < propNames.length; idx++) {
					name = propNames[idx];
					value = propValues[idx];
					child[name] = value;
					// force algo eval
					child['Contact'] = child['Contact'];
				}
				visitor.count++;
			}
		}
	}
	
	element.walk(visitor);
	session.sendMessage('Set ' + visitor.count + ' elements');
})();
