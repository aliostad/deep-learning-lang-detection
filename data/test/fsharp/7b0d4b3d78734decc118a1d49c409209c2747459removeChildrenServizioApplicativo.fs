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
//		The purpose of this script is to give a right-click operation to remove children
//      for element of class ServizioApplicativo
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
//		1) copy removeChildrenServizioApplicativo.fs to formula/database/scripts/custom/operations
//		2) create a right-click operation as portrayed below...
//
/*

[Structure|Remove Children of ServizioApplicativo]
command=
context=element
description=Structure|Remove Children of ServizioApplicativo
operation=load('custom/operation/removeChildrenServizioApplicativo.fs');session.sendMessage('Children of Servizio Applicativo removed');
permission=manage
target=dname:root=Organizations
type=serverscript

 */
//
//
load('custom/orgs/ElementManager.fs');

function removeChildrenServizioApplicativo(ele) 
{
	var clazz = ele.elementClassname + '';
	if (clazz == 'ServizioApplicativo') {
		var dn = ele.DName
		formula.log.info('Removing children of ' + dn);
		// remove explicitly
		var ele = formula.Root.findElement('DispSrzApplSource=BAC/DisponibilitaSrzAppl=Disponibilita/' + dn);
		ele.perform( session, 'LifeCycle|Delete', [], [] );
		var ele = formula.Root.findElement('DispSrzApplSource=Gomez/DisponibilitaSrzAppl=Disponibilita/' + dn);
		ele.perform( session, 'LifeCycle|Delete', [], [] );
		var ele = formula.Root.findElement('DispSrzApplSource=BAC/DisponibilitaSrzAppl=Disponibilita/' + dn);
		ele.perform( session, 'LifeCycle|Delete', [], [] );
		var ele = formula.Root.findElement('DisponibilitaSrzAppl=Disponibilita/' + dn);
		ele.perform( session, 'LifeCycle|Delete', [], [] );
		var ele = formula.Root.findElement('IncidentSrzAppl=Incident/' + dn);
		ele.perform( session, 'LifeCycle|Delete', [], [] );
		var ele = formula.Root.findElement('SistemiSrzAppl=Sistemi/' + dn);
		ele.perform( session, 'LifeCycle|Delete', [], [] );
		var ele = formula.Root.findElement('SlaSrzAppl=SLA/' + dn);
		ele.perform( session, 'LifeCycle|Delete', [], [] );
		// just in case anything is left over
		ElementMngr.removeChildren(ele.Dname);
	}
}

formula.log.info('Removing children starting from ' + element.Dname);
element.walk(removeChildrenServizioApplicativo);