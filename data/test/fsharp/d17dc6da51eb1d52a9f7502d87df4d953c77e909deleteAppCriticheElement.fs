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
//		Delete element with DispSrzApplSource=AppCritiche
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

[Structure|Tree|Delete AppCritiche]
command=
context=element
description=Tree|Delete AppCritiche
operation=load('custom/operation/deleteAppCritiche.fs');\r\nvar res = deleteAppCritiche(element);\r\nsession.sendMessage('Deleted ' + res + ' AppCritiche elements');
permission=manage
target=dname:root=Organizations
type=serverscript

 */
//
//

function deleteAppCritiche(ele) 
{
	var delAppCriticheVisitor =
		{
			found: false,
			count: 0,
			visit: function ( child ) {
			
				var clazz = child.elementClassname + '';
				var name = child.Name;
				if (clazz == "DispSrzApplSource" && name == "AppCritiche") {
					state.Orgs.deleteElement(child);
					delAppCriticheVisitor.count++
				}
			}
		}
	
	ele.walk(delAppCriticheVisitor);
	return delAppCriticheVisitor.count;
}
