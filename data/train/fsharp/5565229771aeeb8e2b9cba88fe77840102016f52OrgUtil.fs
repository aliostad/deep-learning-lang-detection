/*

    Script OrgUtil.fs

  Author: Bomitali Evelino
  Tested with versions: 5.0

  Functions to find/create/delete elements

  [Test|Create Element]
  command=
  context=element
  description=Test|Create Element
  operation=load('custom/orgs/createElement.fs');
  permission=view
  target=dname:gen_folder=test/root=Generational+Models/root=Services
  type=serverscript

 */

var logger = Packages.org.apache.log4j.Logger.getLogger("fs.OrgUtil");
logger.debug('Loading OrgUtil');

function OrgUtil () {
}

// create a new element, server script
// pars used to build dname (that is as string)
OrgUtil.createElement = function(clazz, name, parentDn) {
    var propNames = new Array();
    var propValues = new Array();
    return OrgUtil.createElementExt(clazz, name, parentDn, propNames, propValues)
}

OrgUtil.createElementExt = function(clazz, name, parentDn, propNames, propValues) {

    // find the parent
    var res = false;
    var parent;
    var msg = '';
    try {
        parent = formula.Root.findElement(parentDn);
    } catch (Exception) {
        msg = "createElement unable to locate parent element: " + Exception;
        logger.info(msg);
        formula.log.info(msg);
    }

    // Find the new class to add.
    var orgClass;
    try {
        orgClass = parent.elementClass.findChild( clazz )
    } catch (Exception) {
        msg = "Unable to find class child: " + Exception;
        logger.info(msg);
        formula.log.info(msg);
    }

    // add the new organization
    try {
        orgClass.newElement( session.getReference(), parent, name, propNames, propValues );
        res = true;
    } catch (Exception) {
        msg = "Unable to create new element:" + Exception;
        logger.info(msg);
        formula.log.info(msg);
    }
    return res;
}

OrgUtil.createElementMatches = function(clazz, name, parentDn, aMatch) {
	var res;
    var propNames = new Array();
	propNames.push('Matches');
    var propValues = new Array();
	propValues.push(aMatch);
	res = OrgUtil.createElementExt (clazz, name, parentDn, propNames, propValues);
	return res;
}

OrgUtil.findElement = function (eleDn) {
    var res = null;
    try {
        res = formula.Root.findElement(eleDn);
    } catch (Exception){
        //nothing to do
        logger.error('OrgUtil.findElement: unable to find ' + eleDn);
    }
    return res;
}

// from NOC example files, to be tested
// maybe should use  element.perform( session, 'LifeCycle|Delete', [], [] )
OrgUtil.deleteOrg = function(ele)
{
    var res = '';
    try {
        ele.perform( session, 'LifeCycle|Delete', [], [] );
    } catch (Exception) {
        res = 'Error deleting ' +  ele.Dname + ' : ' + Exception;
        formula.log.error(res);
        return res;
    }
    return 'Deleted ' + dname;
}

/////////////////////////////////////////////////////////////////////////////////////
// Delete an existing organization
//
// dname: DName of the organization element to delete
//
OrgUtil.deleteElement = function (dname)
{
    // find child and parent
    var child
    try {
        child = formula.Root.findElement(dname)
    } catch (Exception) {
        return "Unable to locate the specified element:" + Exception
    }

    try {
        child.destroy()
        return ""
    } catch (Exception) {
        return "Unable to delete organization: " + Exception
    }
}

//loop on element children and deletes them
OrgUtil.deleteChildren = function(dname) {
    logger.debug('OrgUtil.deleteChildren ' + dname);
    var parent, children;
    try {
        parent = formula.Root.findElement(dname)
    } catch (Exception) {
        return "Unable to locate the specified element:" + Exception
    }
    children = parent.Children;
    logger.debug('Found ' + children.length + ' children');
    try {
        for (var i = 0; i < children.length; i++) {
            logger.debug(OrgUtil.deleteElement(children[i]));
        }
    }catch (Exception) {
        return "Exception trying to delete children :" + Exception
    }
    return '';
}

OrgUtil.mapDn = function(dn, from, to) {
	var idx = dn.lastIndexOf(from)
	logger.debug('Mapping: ' + dn)
	var resDn = dn.substr(0,idx) + to;
	logger.debug('Mapped: ' + resDn)
	return resDn
}

/* parent.copy works on PB3 + PLUS
// copy an element and its subtree under destDN
OrgUtil.copyElement = function(ele,destDn) {
	logger.debug('copyElement - ele: ' + ele.dname);
    logger.debug('copyElement - target parent: ' + destDn);
	try {
		parent = formula.Root.findElement(destDn);
		// nota: source.id() non è accessibile da un contesto formula script (solo server side ?)
		// ed origina errore, l'equivalente è source.id
		// mentre all'interno di questa funzione di copy è perfettamente legittimo
		parent.copy(session.getReference(), ele.id(), formula.relations.NAM);
	} catch (copyError) {
        logger.error('copyElement - error in copying ' + copyError);
	}
}
}
*/

/* parent.copy seems to be not available for com.mosol.Adapter.Formula.Group.copy
OrgUtil.copyChildren = function(ele,destDn) {
    var parent, currEle, Children;
    logger.debug('copyElement - ele: ' + ele.dname);
    logger.debug('copyElement - target parent: ' + destDn);
    try {
        parent = formula.Root.findElement(destDn);
        Children = ele.Children;
        // nota: source.id() non è accessibile da un contesto formula script (solo server side ?)
        // ed origina errore, l'equivalente è source.id
        // mentre all'interno di questa funzione di copy è perfettamente legittimo
        for (var i=0; i<Children.length; i++){
            currEle = Children[i];
            parent.copy(session.getReference(), currEle.id(), formula.relations.NAM);
        }
    } catch (copyError) {
        logger.error('copyElement - error in copying ' + copyError);
    }
}
*/


// Very useful, return a javascript string
OrgUtil.getElementClass = function(ele) {
    // esempio tratto dal file algorithms.xml
    //ele.getElementClass().getName();
    return ele.elementClassName + "";
}

// list of OrgInfo
// pathRoot should exist
/* Bisogna fare qualche altra riflessione. Se devo costruire una catena di elementi
non dovrei avere il path nella definizione dell'elemento, come nel caso di OrgInfo,
però prendersi semplicemente il dname e fare ragionamenti sul percorso da costruire è complesso,
bisogna considare tutti i casi e la possibilità che un / non sia un separatore tra padre e figlio
ma sia nel nome dell'elemento o classe (se viene quotato...)
OrgUtil.createPath = function (lOrgInfo, pathRoot) {
    var eleRoot = OrgUtil.findElement(pathRoot);
    if (eleRoot != null){
    for (var i = 0; i < lOrgInfo.length; i++) {

    }
    }
}
*/



