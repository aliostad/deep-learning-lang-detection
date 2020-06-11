<?php

namespace SclZfCartTests\TestAssets;

use SclZfCart\Customer\CustomerLocatorInterface;
use SclZfCart\Customer\CustomerInterface;

/**
 * For use in tests to inject a "logged in" customer object.
 *
 * @author Tom Oram <tom@scl.co.uk>
 */
class TestCustomerLocator implements CustomerLocatorInterface
{
    private static $customer;

    public static function setCustomer(CustomerInterface $customer)
    {
        self::$customer = $customer;
    }

    public function getActiveCustomer()
    {
        return self::$customer;
    }
}
