//
// Copyright (c) 2012 Hogwart, Inc.  All Rights Reserved.
//
// Stop ImpModel adapter, then restart
//
/* Example
 [_Adapter|Restart]
 command=
 context=element
 description=_Adapter|Restart
 operation=load( 'custom/lib/AdaptersUtil.fs' );\nformula.log.info('Adapter is ' + element.name);\nAdaptersUtil.restartAdapter(element.name);
 permission=view
 target=script:element.parent.DName=='root=Elements'
 type=serverscript
 */

var AdaptersUtil = (function () {

    var _logger = Packages.org.apache.log4j.Logger.getLogger('fs.adaptersutil');

    // may be a dname or a name
    var findAdapter = function (adpt) {
        // should check if the two methods returns the same king of objects


        var adapter = null;
        if (state.DNamer.isDName(adpt)) {
            var mgrElement = formula.Root.findElement(adpt);
            adapter = mgrElement.adapter;
        } else {
            // returns com.mosolo.ORB.formula....
            var adapters = formula.server.adapters();
            for (var i = 0; i < adapters.length; ++i) {
                _logger.debug('key is ' + adapters[i].key());
                if (adapters[i].key() == adpt) {
                    adapter = adapters[i];
                    break;
                }
            }
        }
        return adapter;
    }

    var getStatus = function (adapter) {
        var status = ''
        try {
            status = adapter.manageStatus()
        } catch (excp) {
            status = "Exception: " + excp
        }
        return status
    }

    var checkStopped = function (adptDn) {
        var mgrElement = formula.Root.findElement(adptDn);
        adapter = mgrElement.adapter;
        var status = ''
        try {
            status = adapter.manageStatus()
        } catch (excp) {
            status = "Exception: " + excp
        }
        return status === 'stopped'
    }

    // deprecated
    var restartImpModel = function () {
        _logger.debug('restartImpModel, starting')
        try {
            var adapter = findAdapter('ImpModello=Adapter%3A+ImpModello/root=Elements');
            /*
             // Get adapters.
             var adapters = formula.server.adapters()
             _logger.debug('Found adapters')
             for (var i = 0; i < adapters.length; ++i) {
             adapter = adapters[i]
             _logger.debug('Found adapter ' + adapter.key())
             if (adapter.key() == 'Adapter: ImpModello') {
             break
             }
             }
             */

            if (adapter) {
                status = adapter.manageStatus()
                _logger.debug('restartImpModel, adapter ' + adapter.key() + ', status: ' + status);

                if (status != 'stopped') {
                    adapter.manageStop()
                    _logger.debug('restartImpModel, stopped adapter ' + adapter.key());
                }

                //should be enough to stop the adapter
                java.lang.Thread.sleep(10000);
                _logger.debug('restartImpModel, starting adapter ' + adapter.key());
                adapter.manageStart()
                status = adapter.manageStatus()
                _logger.debug('restartImpModel, adapter ' + adapter.key() + ' : ' + status);
                // wait a little after restart to allow bdi to process query
                java.lang.Thread.sleep(4000);
            }

        }
        catch (excp) {
            _logger.error('restartImpModel, exception: ' + excp);
            status = 'Exception: ' + excp
        }
        _logger.info('restartImpModel, adapter ImpModello restarted:' + status)
        _logger.debug('restartImpModel completed')
    }

    // status = Adapter Starting|Adapter Started|stopped
    var restartAdapter = function (pAdapterKey) {
        _logger.info('_restartAdapter, restarting ' + pAdapterKey)
        try {

            /*
             // Get adapters.
             var adapters = formula.server.adapters()
             var adapter = null, status = '';

             for (var i = 0; i < adapters.length; ++i) {
             adapter = adapters[i]
             _logger.debug('Found adapter ' + adapter.key())
             if (adapter.key() == pAdapterKey) {
             break
             }
             }
             */

            var adapter = findAdapter('ImpModello=Adapter%3A+ImpModello/root=Elements');
            if (adapter) {
                status = adapter.manageStatus()
                _logger.debug('_restartAdapter, adapter ' + adapter.key() + ' status >' + status + '<');

                if (status != 'stopped') {
                    adapter.manageStop()
                    _logger.debug('_restartAdapter, stopping adapter ' + adapter.key());

                    while (status != 'stopped') {
                        status = adapter.manageStatus();
                        java.lang.Thread.sleep(500);
                    }
                    _logger.debug('_restartAdapter, stopped adapter ' + adapter.key() + ' status >' + status + '<');
                }

                _logger.debug('_restartAdapter, starting adapter ' + adapter.key());
                adapter.manageStart();
                status = adapter.manageStatus();
                _logger.debug('_restartAdapter, starting adapter ' + adapter.key() + ' status >' + status + '<');

                for (var i = 0; i < 10; ++i) {
                    status = adapter.manageStatus();
                    _logger.debug('_restartAdapter, starting adapter ' + adapter.key() + ' status >' + status + '<');
                    java.lang.Thread.sleep(500);
                    if (status == 'Adapter started.') {
                        break
                    }
                }
                // wait for bdi query execution and processing
                java.lang.Thread.sleep(5000);
            }
        }
        catch (excp) {
            _logger.error('restartAdapter exception: ' + excp);
        }
        _logger.info('restartAdapter completed')
    }

    // generate the event in order to trigger RunOnce schedule, that is fire query to db and update
    // the structure un Elements with data from updated tables
    var _runImpModelloBdi = function () {
        // Now rebuild the structure under Generational Models, the structure will be used as a template for Production
        _logger.info('Send bdi event to ImpModello');
        load('util/bdievent');
        fireBDIEvent('RunOnce', 'Adapter: ImpModello');
        // wait 5 seconds
        Packages.java.lang.Thread.sleep(5000);
    }
	
	// generate the event in order to trigger a schedule on a bdi adapter (adapter key)
	// ie: schedule = 'RunOnce', adpt = 'Adapter: ImpModello'
    var runBdiSchedule = function (sched, adptName) {
        // Now rebuild the structure under Generational Models, the structure will be used as a template for Production
        _logger.info('Send bdi event ' + sched + ' to ' + adptName);
        load('util/bdievent');
        fireBDIEvent(sched, adptName);
        // wait 5 seconds
        Packages.java.lang.Thread.sleep(5000);
    }

    return {
        restartAdapter:restartAdapter,
        checkStopped:checkStopped,
        findAdapter:findAdapter,
        getStatus:getStatus,
		runBdiSchedule:runBdiSchedule
    }
})()
