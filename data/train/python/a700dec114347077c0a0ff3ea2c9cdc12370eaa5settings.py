# -*- coding: utf-8 -*-


XMLRPC_METHODS = {
    'nitrate_XMLRPC': (
        ('nitratexmlrpc.api.auth', 'Auth'),
        ('nitratexmlrpc.api.build', 'Build'),
        ('nitratexmlrpc.api.env', 'Env'),
        ('nitratexmlrpc.api.product', 'Product'),
        ('nitratexmlrpc.api.testcase', 'TestCase'),
        ('nitratexmlrpc.api.testcaserun', 'TestCaseRun'),
        ('nitratexmlrpc.api.testcaseplan', 'TestCasePlan'),
        ('nitratexmlrpc.api.testopia', 'Testopia'),
        ('nitratexmlrpc.api.testplan', 'TestPlan'),
        ('nitratexmlrpc.api.testrun', 'TestRun'),
        ('nitratexmlrpc.api.user', 'User'),
        ('nitratexmlrpc.api.version', 'Version'),
        ('nitratexmlrpc.api.tag', 'Tag'),
    ),
}

XMLRPC_TEMPLATE = 'xmlrpc.html'
