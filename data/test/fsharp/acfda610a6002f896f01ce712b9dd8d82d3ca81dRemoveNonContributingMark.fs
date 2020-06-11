/*

 Operation Remove Non Contributing Mark.fs

 Author: Bomitali Evelino
 Tested with versions: 5.0
 
[_Element|Remove non contrib mark]
command=
context=element
description=_Element|Remove non contrib mark
operation=load('custom/operation/RemoveNonContributing.fs');
permission=manage
target=namematch:.*
type=serverscript

 */

load('custom/lib/underscore.js');

(function (child) {
 
	var _logger = Packages.org.apache.log4j.Logger.getLogger('fs.op.removenoncontributingmark');
	var _addSource = function (sourceDn, ele)
    {
        var newSource = null;
        try {
            newSource = formula.Root.findElement(sourceDn); // we check if the source really exists

            var values = ele["SourceElements"]; // reading existing elements
            if (!(_.contains(values, sourceDn))) {

                values[values.length] = newSource.DName; // adding new DName
                ele["SourceElements"] = values; // writing back
            }
            values = ele["Children"]; // reading existing elements
            if (!(_.contains(values, sourceDn))) {
                values[values.length] = newSource.DName; // adding new DName
                ele["Children"] = values; // writing back
            }
        } catch (excp) {
            formula.log.error('remove non contributing mark: ' + excp)
			_logger.error('remove non contributing mark: ' + excp)
        }
    }
 
    var parentDn = state.DNamer.parseDn(child.DName).parent;
    var parent = formula.Root.findElement(parentDn);
    _addSource(child.Dname, parent);
 
 })(element);