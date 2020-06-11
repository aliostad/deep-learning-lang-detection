<?php
namespace SoftwareEngineerTest;

error_reporting(E_ALL);
ini_set('display_errors', 1);

require_once ('question_2.php');

// Question 3
/**
 * Class CustomerFactory
 * Customer factory to instantiate the correct customer object
 * @package SoftwareEngineerTest
 */
class CustomerFactory
{
    /**
     * @var array $types array with prefix and customer type
     */
    public static $types = array(
        Bronze_Customer::CUSTOMER_TYPE_PREFIX => Bronze_Customer::CUSTOMER_TYPE,
        Silver_Customer::CUSTOMER_TYPE_PREFIX => Silver_Customer::CUSTOMER_TYPE,
        Gold_Customer::CUSTOMER_TYPE_PREFIX => Gold_Customer::CUSTOMER_TYPE
    );

    /**
     * Check if valid customerId or not
     *
     * First character with customer type prefix followed by a set of numbers
     * No longer than 10 characters total
     *
     * @param string $customerId
     * @return bool true if valid otherwise false
     */
    public static function isValidCustomerId($customerId)
    {
        // Valid if Customer Id is no longer than 10 characters.
        // Valid when first character match with customer type prefix followed by a set of numbers
        return (strlen($customerId) > 0
            && strlen($customerId) <= 10
            && is_numeric(substr($customerId, 1))
            && array_key_exists(strtoupper($customerId[0]), self::$types)
        ) ? true : false;
    }

    /**
     * Get valid customer type from given id
     *
     * @param string $customerId
     * @return mixed valid customer type on success otherwise error
     * @throws \Exception throw an error when invalid customer id
     */
    public static function getCustomerType($customerId)
    {
        // Validate customer id
        if (!self::isValidCustomerId($customerId)) {

            throw new \Exception("InvalidArgument");
        }

        return self::$types[$customerId[0]];
    }

    /**
     * Factory method to instantiate the correct customer object
     *
     * Validate given customer id, Get correct customer type and instantiate an object
     *
     * @param string $customerId The customer id
     * @return mixed Customer object on success otherwise an error
     * @throws \Exception throw an error
     */
    public static function get_instance($customerId)
    {
        // Get customer type by validating customer id
        $customerType = self::getCustomerType($customerId);
        // Instantiate correct customer type object
        $customer = '\\SoftwareEngineerTest\\' . $customerType . '_Customer';
        if (class_exists($customer)) {

            return new $customer($customerId);
        } else {

            throw new \Exception("Customer class does not exists");
        }
    }
}

/*
 * Examples
 */

//Bronze customer
/** @var Bronze_Customer $bronzeCustomer */
//$bronzeCustomer = CustomerFactory::get_instance('B123456789');
//echo $bronzeCustomer->type;

//Silver customer
/** @var Silver_Customer $bronzeCustomer */
//$silverCustomer = CustomerFactory::get_instance('S123456789');
//echo $silverCustomer->type;


//Gold customer
/** @var Gold_Customer $bronzeCustomer */
//$goldCustomer = CustomerFactory::get_instance('G123456789');
//echo $goldCustomer->type;