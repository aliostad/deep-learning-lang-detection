<?php
$reqtype = 'sales';
/*Gerçek Hesap Ýþlemleri*/
/*<Aktif>*/
API::$real_gateway = 'domain';
API::$real_gatpath = '/subfolders';
API::$real_apimode = 'PROD'; // PROD - TEST
API::$real_apiprovuserid = 'PROVAUT';
API::$real_apipropassword = '';
API::$real_apiagentuserid = '';
API::$real_apimerchantid = '';
API::$real_apiterminalid = '';
/*</Aktif>*/
/*Test, Sahte Hesap Ýþlemleri*/
/*<Test>*/
API::$test_gateway = 'domain';
API::$test_gatpath = '/subfolders';
API::$test_apimode = 'PROD'; // PROD - TEST
API::$test_apiprovuserid = '';
API::$test_apipropassword = '';
API::$test_apiagentuserid = '';
API::$test_apimerchantid = '';
API::$test_apiterminalid = '';
API::$timeout = 90;
?>