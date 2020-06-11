<?php

use yii\helpers\Html;
use yii\widgets\DetailView;

/* @var $this yii\web\View */
/* @var $model app\models\ResrveCustomer */

$this->title = $model->customer_no;
$this->params['breadcrumbs'][] = ['label' => Yii::t('app', 'Resrve Customers'), 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="resrve-customer-view">

    <h1><?= Html::encode($this->title) ?></h1>

    <p>
        <?= Html::a(Yii::t('app', 'Update'), ['update', 'id' => $model->customer_no], ['class' => 'btn btn-primary']) ?>
        <?= Html::a(Yii::t('app', 'Delete'), ['delete', 'id' => $model->customer_no], [
            'class' => 'btn btn-danger',
            'data' => [
                'confirm' => Yii::t('app', 'Are you sure you want to delete this item?'),
                'method' => 'post',
            ],
        ]) ?>
    </p>

    <?= DetailView::widget([
        'model' => $model,
        'attributes' => [
            'customer_no',
            'customer_code',
            'customer_id01',
            'customer_id02',
            'reference_year_01',
            'reference_year_02',
            'reference_year_03',
            'customer_last_name:ntext',
            'customer_first_name:ntext',
            'customer_middle_name:ntext',
            'customer_name2:ntext',
            'customer_nickname:ntext',
            'customer_password',
            'customer_ssn',
            'customer_passport_no:ntext',
            'customer_passport_expiry_date',
            'customer_salutation',
            'customer_last_name2:ntext',
            'customer_first_name2:ntext',
            'customer_job_title:ntext',
            'customer_company_name:ntext',
            'customer_company_address1:ntext',
            'customer_company_address2:ntext',
            'customer_company_address3:ntext',
            'customer_company_address4:ntext',
            'customer_max_edu',
            'customer_coordinator_contact:ntext',
            'customer_organization_url:ntext',
            'customer_flag',
            'customer_status',
            'customer_primary_contact_name:ntext',
            'customer_primary_contact_last_name:ntext',
            'customer_primary_contact_mobile',
            'customer_secondary_contact_name:ntext',
            'customer_secondary_contact_last_name:ntext',
            'customer_no_of_siblings',
            'customer_secondary_contact_mobile',
            'customer_parent_name:ntext',
            'customer_parent_last_name:ntext',
            'customer_enroll_date',
            'customer_start_date',
            'customer_start_level',
            'customer_nature1',
            'customer_nature2',
            'customer_nature3',
            'customer_nature4',
            'customer_nature5',
            'customer_picture01',
            'customer_picture02',
            'customer_picture03',
            'customer_picture04',
            'customer_picture05',
            'customer_organization',
            'customer_address1:ntext',
            'customer_address2:ntext',
            'customer_address3:ntext',
            'customer_address4:ntext',
            'customer_area_no',
            'customer_state_no',
            'customer_postcode_no',
            'customer_country_no',
            'customer_tel:ntext',
            'customer_mobile:ntext',
            'customer_fax:ntext',
            'customer_email:email',
            'customer_gender_no',
            'customer_classlevel_no',
            'customer_major_no',
            'customer_birthdate',
            'customer_dbtr_link',
            'customer_royalty_no',
            'customer_discover:ntext',
            'customer_bouncebk',
            'customer_userdefine1:ntext',
            'customer_userdefine2:ntext',
            'customer_userdefine3:ntext',
            'customer_userdefine4',
            'customer_userdefine5',
            'customer_userdefine6',
            'customer_userdefine7',
            'customer_userdefine8',
            'customer_userdefine9',
            'customer_userdefine10',
            'customer_sorting',
            'customer_sys_last_mod_date',
            'customer_sys_last_mod_user',
            'customer_sys_delete_flag',
            'consult_card_no',
            'customer_branch',
            'customer_age_range',
            'customer_race',
            'customer_query_promo',
            'customer_query_comm',
            'customer_source',
            'customer_remark:ntext',
            'customer_point',
            'customer_sys_last_create_date',
            'customer_sys_last_create_user',
            'customer_min_redeem_point',
            'customer_parent_gender_no',
            'customer_parent_email:email',
            'customer_parent_mobile:ntext',
            'customer_vat_group',
        ],
    ]) ?>

</div>
