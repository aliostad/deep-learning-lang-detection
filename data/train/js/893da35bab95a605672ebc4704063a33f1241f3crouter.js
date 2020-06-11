var express = require('express');
var fs = require('fs');
var Api = require('./api');

var router = express.Router();
var api = new Api();

router.all('/api/Dns.Record.Create', api.dnsRecordCreate.bind(api));
router.all('/api/Dns.Record.List', api.dnsRecordList.bind(api));
router.all('/api/Dns.Record.Remove', api.dnsRecordRemove.bind(api));
router.all('/api/Dns.Record.Cached', api.dnsRecordCached.bind(api));
router.all('/api/Dns.Record.Clean', api.dnsRecordClean.bind(api));
router.all('/api/Dns.Record.Info', api.dnsRecordInfo.bind(api));
router.all('/api/Proxy.Rule.Info', api.proxyRuleInfo.bind(api));
router.all('/api/Proxy.Rule.List', api.proxyRuleList.bind(api));
router.all('/api/Proxy.Rule.Create', api.proxyRuleCreate.bind(api));
router.all('/api/Proxy.Rule.Remove', api.proxyRuleRemove.bind(api));
router.all('/api/Service.Notice.Status', api.serviceNoticeStatus.bind(api));
router.all('/api/Service.Notice.List', api.serviceNoticeList.bind(api));
router.all('/api/Service.Notice.Read', api.serviceNoticeRead.bind(api));
router.all('/api/Service.Notice.Clean', api.serviceNoticeClean.bind(api));
router.all('/api/Statistics.Dns.Reqs.Month', api.statisticsDnsReqs('month').bind(api));
router.all('/api/Statistics.Dns.Reqs.Day', api.statisticsDnsReqs('day').bind(api));
router.all('/api/Statistics.Dns.Reqs.Hour', api.statisticsDnsReqs('hour').bind(api));
router.all('/api/Statistics.Proxy.Flow.Month', api.statisticsProxyFlow('month').bind(api));
router.all('/api/Statistics.Proxy.Flow.Day', api.statisticsProxyFlow('day').bind(api));
router.all('/api/Statistics.Proxy.Flow.Hour', api.statisticsProxyFlow('hour').bind(api));

module.exports = router;