<?php
/**
 * 客户模型
 * */
class Customer extends AppModel {

    /** 查询条件数组 */
    public $options = array(
        'list' => array(
            'fields' => array(
                'Customer.id',
                'Customer.name',
                'Customer.simple_name',
                'Customer.linkman',
                'Customer.tel',
                'Customer.mobile',
                'Customer.addr',
                'Customer.type',
                'Customer.status',
                'Customer.detail'
            )
        )
    );
}