/*

  Script BuildItaliaStar.fs

  Author: Bomitali Evelino
  Tested with versions: 5.0

  Build Italia ITA o Italia RMA structure
  - restart adatper (to read data, todo)
  - build Gen Mod/Helper/ItaliaITA or ItaliaRMA
  - build Service Models/Italia ITA or Italia RMA
  The script does not build Service Models/Helper/ItaliaITA as this is attached to the svg, so removing or adding 
  elements may be troublesome

 [Build|Build ItaliaITA]
 command=
 context=element
 description=Build ItaliaITA
 operation=load('custom/view/BuildItaliaStar.fs');\nvar msg = agenzieViewBuilder.run(element);\nsession.sendMessage('Build Italia ITA res ' + msg);
 permission=manage
 target=dnamematch:^formula=Italia\\+ITA/root=Organizations
 type=serverscript
 
 [Build|Build ItaliaRMA]
 command=
 context=element
 description=Build ItaliaRMA
 operation=load('custom/view/BuildItaliaStar.fs');\nvar msg = agenzieViewBuilder.run(element);\nsession.sendMessage('Build Italia ITA res ' + msg);
 permission=manage
 target=dnamematch:^formula=Italia\\+RMA/root=Organizations
 type=serverscript

 */

var agenzieViewBuilder = (function (){

    var _logger = Packages.org.apache.log4j.Logger.getLogger("fs");
    // restart adapter
    // todo
    _helperRootDname = 'gen_folder=Helper/root=Generational+Models/root=Services';
    _helperRoot = null;

    _parseDn = function (dn) {
        var patt = /(([^=]*)=([^\/]*))\/(.*)/
        var match = patt.exec(dn);
        return {
            classAndName: match[1],
            name: formula.util.decodeURL(match[3]),
            className: formula.util.decodeURL(match[2]),
            encodedName: match[3],
            encodedClassName: match[2],
            parent:match[4]
        }
    }

    var run = function (viewRoot) {

		// restart adapter, todo
        var res = 'KO';
        var parsed = _parseDn(viewRoot.Dname);
        var hdn = null;
        if (parsed.encodedName == 'Italia+ITA')
            hdn = 'gen_folder=ItaliaITA' + '/' + _helperRootDname;
        else if (parsed.encodedName == 'Italia+RMA')
            hdn = 'gen_folder=ItaliaRMA' + '/' + _helperRootDname;
        else
            hdn = parsed.classAndName  + '/' + _helperRootDname;
        _logger.info('hdn ' + hdn);
        try {

            _helperRoot = formula.Root.findElement(hdn);
            _helperRoot.perform( session, "ViewBuilder|Run", [], [] );
            viewRoot.perform( session, "ViewBuilder|Run", [], [] );
            res = 'OK';

        } catch( excp ) {
            _logger.error('Got error ' + excp)
        }

        _logger.info('Building ' + parsed.name + ' completed exit: ' + res);
        return res;
    }

    return {
            run: run
    }
}());