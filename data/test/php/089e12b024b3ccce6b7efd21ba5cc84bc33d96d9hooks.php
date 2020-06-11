<?php

$config['module[customer].is_accessible'][] = 'Customer::is_accessible';


$config['is_allowed_to[购买].product'][] = 'Customer::customer_ACL';


$config['is_allowed_to[以买方查看].order'][] = 'Customer::customer_ACL';
$config['is_allowed_to[以买方确认].order'][] = 'Customer::customer_ACL';
$config['is_allowed_to[买方确认订单].order'][] = 'Customer::customer_ACL';
$config['is_allowed_to[付费].order'][] = 'Customer::customer_ACL';
$config['is_allowed_to[退货].order'][] = 'Customer::customer_ACL';
$config['is_allowed_to[以买方取消].order'][] = 'Customer::customer_ACL';
$config['is_allowed_to[以买方驳回].order'][] = 'Customer::customer_ACL';
$config['is_allowed_to[确认收货].order'][] = 'Customer::customer_ACL';
// $config['is_allowed_to[修改付费账号].order'][] = 'Customer::customer_ACL';
// $config['is_allowed_to[确认付费].order'][] = 'Customer::customer_ACL';

$config['is_allowed_to[评价].order_item'][] = 'Customer::customer_ACL';

$config['is_allowed_to[买方查看].customer'][] = 'Customer::customer_ACL';
$config['is_allowed_to[以买方成员修改信息].customer'][] = 'Customer::customer_ACL';
$config['is_allowed_to[买方修改成员信息].customer'][] = 'Customer::customer_ACL';
$config['is_allowed_to[买方修改成员权限].customer'][] = 'Customer::customer_ACL';
$config['is_allowed_to[列表付款单].customer'][] = 'Customer::customer_ACL';
$config['is_allowed_to[列表订单].customer'][] = 'Customer::customer_ACL'; 
$config['is_allowed_to[添加订单].customer'][] = 'Customer::customer_ACL';

$config['is_allowed_to[修改].transfer_bucket'][] = 'Customer::customer_ACL';
$config['is_allowed_to[生成付款单].transfer_bucket'][] = 'Customer::customer_ACL';

$config['is_allowed_to[查看].transfer_statement'][] = 'Customer::customer_ACL';
$config['is_allowed_to[删除].transfer_statement'][] = 'Customer::customer_ACL';
$config['is_allowed_to[确认付费].transfer_statement'][] = 'Customer::customer_ACL';
//添加取消订单功能 edit by sunxu 2015-04-15
$config['is_allowed_to[取消付费].transfer_statement'][] = 'Customer::customer_ACL';

$config['is_allowed_to[发表评论].order'][] = 'Customer::comment_ACL';
$config['is_allowed_to[删除].comment'][] = 'Customer::comment_ACL';

$config['order_approval_required'][] = 'Customer::check_order_approval_required';
