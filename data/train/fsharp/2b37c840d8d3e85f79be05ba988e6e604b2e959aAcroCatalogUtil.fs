/*

    Script AcroCatalogUtil.fs

  Author: Bomitali Evelino
  Tested with versions: 5.0

  Utilities to manage Acronimo Catalog

  [Test|Create Element]
  command=
  context=element
  description=Test|Create Element
  operation=load('custom/orgs/createElement.fs');
  permission=view
  target=dname:gen_folder=test/root=Generational+Models/root=Services
  type=serverscript

 */

var logger = Packages.org.apache.log4j.Logger.getLogger("Dev");
logger.debug('Starting AcroCatalogMngr');

load('custom/orgs/MatchHndlr.fs');

// start from element, walk up to Acronimo, connect to Acro Catalog Acronimo, set DisplayChildren

var mRoot = element;

function adjustAcronimo (ele) {
    var clazz = ele.elementClassName + '';
    if (clazz == 'Acronimo') {
        ele.DisplaySourceElements = 'true';
        MatchHndlr.matchAcronimoToAcroCatalog(ele);
    }
}

mRoot.walk(adjustAcronimo);
logger.debug('AcroCatalogMngr ended');