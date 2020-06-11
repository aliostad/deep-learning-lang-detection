//	clearServizioApplicativoStructure.fs
//
//	VERSION INFORMATION
//		Version: 1.01
//
//		2014June07 - 1.00 Created by Evelino Bomitali
//
//
//	Purpose
//		The purpose of this script is to give a right-click operation to navigate a tree
//      and clear the helper structure under an object of class ServizioApplicativo
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
//		1) copy clearServizioApplicativoStructure.fs to formula/database/scripts/custom/operations
//		2) create a right-click operation as portrayed below...
//
/*

 [Structure|Tree|Clear ServizioApplicativo Structure]
command=
context=element
 description=Structure|Clear SrzAppl Struct in Tree
 operation=load('custom/operation/clearServizioApplicativoStructure.fs');
permission=manage
 target=dname:gen_folder=Modello/formula=CMS/root=Organizations
type=serverscript

 */
//
//

(function () {

function safeDel (dn) {
	try {
		var ele = formula.Root.findElement(dn);
		ele.perform( session, 'LifeCycle|Delete', [], [] );
	} catch (excp) {
	}
}

function clearServizioApplicativoStructure(ele) 
{
	var dn = ele.Dname;
	var clazz = ele.elementClassName + '';

	/*
	if (clazz == 'ServizioApplicativo') {
		formula.log.info('Clearing ' + dn);
		// reverse order as deleting from an array recompacts the array
		for(var idx = ele.children.length-1 ; idx > -1; idx--){
			ele.children[idx].perform( session, 'LifeCycle|Delete', [], [] )
		}
	}
	*/
	if (clazz == 'ServizioApplicativo') {
		// remove explicitly
            safeDel('DispSrzApplSource=AppCritiche/DisponibilitaSrzAppl=Disponibilita/' + dn);
            safeDel('DispSrzApplSource=BEM/DisponibilitaSrzAppl=Disponibilita/' + dn);
            safeDel('DispSrzApplSource=BSM/DisponibilitaSrzAppl=Disponibilita/' + dn);
		safeDel('DispSrzApplSource=Gomez/DisponibilitaSrzAppl=Disponibilita/' + dn);
		safeDel('DispSrzApplSource=Sitescope/DisponibilitaSrzAppl=Disponibilita/' + dn);
		safeDel('DisponibilitaSrzAppl=Disponibilita/' + dn);
		safeDel('IncidentSrzAppl=Incident/' + dn);
		safeDel('SistemiSrzAppl=Sistemi/' + dn);
		safeDel('SlaSrzAppl=SLA/' + dn);
		// just in case anything is left over

            for(var idx = ele.children.length-1 ; idx > -1; idx--){
                ele.children[idx].perform( session, 'LifeCycle|Delete', [], [] )
            }
	}
}



formula.log.info('Clearing structure ServizioApplicativo from ' + element.Dname);
element.walk(clearServizioApplicativoStructure);
    formula.log.info('Cleared structure ServizioApplicativo');
    
}())


