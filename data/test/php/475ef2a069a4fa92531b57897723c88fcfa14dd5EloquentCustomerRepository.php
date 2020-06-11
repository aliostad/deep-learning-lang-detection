<?php
/**
 * Uses the Eloquent ORM
 *
 * @author Roberto Cipriani <roberto@robertodev.com>
 * @package pizza
 */


namespace Pizza\Customer\Repositories;

use Pizza\Customer\CustomerRepositoryInterface;
use Pizza\Customer\Models\Customer;


class EloquentCustomerRepository implements CustomerRepositoryInterface {


    /**
     *
     *
     * @param $input
     * @return obj
     */
    public function setCustomer($input)
    {
        $customer = new Customer;

        $customer->name = $input['name'];
        $customer->email = $input['email'];
        $customer->save();

        return $customer;
    }

}
