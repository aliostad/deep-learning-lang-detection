//	sendElementFunctionsToClipboard.fs
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
//		anyone that will extract the properties of the selected object and write
//		them to the system clipboard.  Once in the system clipboard, they can then
//		be pasted anywhere else desired.
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
//		1) copy sendElementPropertiesToClipboard.fs to formula/database/scripts/custom/sendElementPropertiesToClipboard.fs
//		2) create a right-click operation as portrayed below...
//
/*

 [_Alarms|Copy Properties to Clipboard]
 command=
 context=element
 description=_Element|Copy Properties to Clipboard
 operation=load( "custom/operation/sendElementPropertiesToClipBoard.fs" );
 permission=view
 target=dnamematch:root=Organizations
 type=serverscript

 */
//
//

function clearIncidentChildren(ele) 
{
	var dn = ele.Dname;
	formula.log.info('Checking ' + dn);
	
	var patt = /^IncidentSrzAppl=Incident/
	var res = patt.exec(dn);
	if (res != null) {
		//var ch = new Array();
		formula.log.info('Clearing ' + dn);
		ele.Children = [];
	}
}

formula.log.info('Clearing from ' + element.Dname);
element.walk(clearIncidentChildren);