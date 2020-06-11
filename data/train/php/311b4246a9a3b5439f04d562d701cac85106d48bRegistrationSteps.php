<?php
/**
 * Created by PhpStorm.
 * User: efutures
 * Date: 12/21/16
 * Time: 2:20 PM
 */
namespace App\Constants;

interface RegistrationSteps
{
    const  registrationSteps =  [
            'show_supplier_singup_subscription' => 'Subscription',
            'show_supplier_singup' => 'Account Details',
            'show_supplier_singup_company_profile' => 'Profile',
            'show_supplier_singup_location' => 'Locations',
            'show_supplier_services' => 'Services',
            'show_supplier_notifications' => 'Notification',
            'show_supplier_singup_submit' => 'Review and Submit',
        ];
}