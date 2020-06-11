//	clearChildrenForIncidentSistemiSLA.fs
//
//	VERSION INFORMATION
//		Version: 1.01
//
//		2005May03 - 1.00 Created by The Unknown Scripter
//		2006Sep07 - 1.01 Comments and cleanup - Ray Parker
//
//
//	Purpose
//		The purpose of this script is to give a right-click operation to
//
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
//		1) copy clearChildrenForIncidentSistemiSLA.fs to formula/database/scripts/custom/operations
//		2) create a right-click operation as portrayed below...
//
/*

[Structure|Clear Children on Incident Sistemi SLA Element]
command=
context=element
description=Structure|Clear Children on Incident Sistemi SLA Element
operation=load('custom/operation/clearChildrenForIncidentSistemiSLA.fs');
permission=manage
target=dname:root=Organizations
type=serverscript

 */
//
//

function clearIncidentChildren(ele) 
{
	var dn = ele.Dname;
	formula.log.info('Checking ' + dn);
	
	var patt = /^(IncidentSrzAppl=Incident|SistemiSrzAppl=Sistemi|SlaSrzAppl=SLA|DisponibilitaSrzAppl=Disponibilita)/
	var res = patt.exec(dn);
	if (res != null) {
		//var ch = new Array();
		formula.log.info('Clearing ' + dn);
		ele.Children = [];
		ele.Sources = []
	}
}

formula.log.info('Clearing from ' + element.Dname);
element.walk(clearIncidentChildren);