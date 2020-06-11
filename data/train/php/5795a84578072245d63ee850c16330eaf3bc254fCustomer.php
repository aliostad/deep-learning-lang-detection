<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "tbcustomer".
 *
 * @property integer $customer_id
 * @property string $customer_name
 * @property string $customer_add1
 * @property string $customer_add2
 * @property string $customer_add3
 * @property integer $customer_poscode
 * @property string $customer_tel
 * @property string $customer_fax
 * @property string $customer_email
 * @property string $customer_type
 * @property string $customer_remark
 * @property string $customer_attention
 * @property string $customer_active
 * @property string $customer_GSTno
 */
class Customer extends \yii\db\ActiveRecord
{
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'tbcustomer';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['customer_name', 'customer_type', 'customer_remark', 'customer_GSTno'], 'required'],
            [['customer_add1', 'customer_add2', 'customer_add3', 'customer_remark'], 'string'],
            [['customer_poscode'], 'integer'],
            [['customer_name', 'customer_attention'], 'string', 'max' => 55],
            [['customer_tel', 'customer_fax'], 'string', 'max' => 15],
            [['customer_email'], 'string', 'max' => 255],
            [['customer_type', 'customer_active'], 'string', 'max' => 1],
            [['customer_GSTno'], 'string', 'max' => 50]
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'customer_id' => 'Customer ID',
            'customer_name' => 'Customer Name',
            'customer_add1' => 'Customer Add1',
            'customer_add2' => 'Customer Add2',
            'customer_add3' => 'Customer Add3',
            'customer_poscode' => 'Customer Poscode',
            'customer_tel' => 'Customer Tel',
            'customer_fax' => 'Customer Fax',
            'customer_email' => 'Customer Email',
            'customer_type' => 'Customer Type',
            'customer_remark' => 'Customer Remark',
            'customer_attention' => 'Customer Attention',
            'customer_active' => 'Customer Active',
            'customer_GSTno' => 'Customer  Gstno',
        ];
    }
}
