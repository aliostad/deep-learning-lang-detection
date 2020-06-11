//	clearPerfSourceStructure.fs
//
//	VERSION INFORMATION
//		Version: 1.01
//
//	Purpose
//		Remove the element added to match sources within Perf/ServizioApplicativo
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
//		1) copy clearPerfSourceStructure.fs to formula/database/scripts/custom/operations
//		2) create a right-click operation as portrayed below...
//
/*

[Structure|Clear Source Structure Perf]
command=
context=element
description=Structure|Clear Source Structure Perf
operation=load('custom/operation/clearPerfSourceStructure.fs');
permission=manage
target=dnamematch:^gen_folder=ServizioApplicativo/logo_managedobjects=Perf/root=Organizations
type=serverscript

 */

(function (startEle) {

    var visitor =
    {
        count: 0,
        deleted: 0,
        found: false,
        visit: function ( ele )
        {
            visitor.count++;
            var clazz = ele.elementClassName + '';

            if (clazz == 'ServizioApplicativo') {
                // reverse order as deleting from an array recompacts the array
                for(var idx = ele.children.length-1 ; idx > -1; idx--){
                    ele.children[idx].perform( session, 'LifeCycle|Delete', [], [] );
                    visitor.deleted++;
                }
            }
        }
    }

    formula.log.info('Clearing sources for ' + startEle.Dname);
    startEle.walk(visitor);
    formula.log.info('Cleared ' + visitor.deleted + ' sources');
})(element);