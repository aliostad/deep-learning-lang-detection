<?php

namespace Voucherify;

class Customer extends VoucherifyRequest {

    /**
     * Customer constructor.
     *
     * @param string $apiID
     * @param string $apiKey
     */
    public function __construct($apiID, $apiKey) {
        parent::__construct($apiID, $apiKey);
    }

    /**
     * @param Customer $customer
     *
     * Create customer.
     *
     * @throws Voucherify\ClientException
     */
    public function create($customer) {
        return $this->apiRequest("POST", "/customers/", NULL, $customer);
    }

    /**
     * @param string $customerId
     *
     * Get customer details
     *
     * @throws Voucherify\ClientException
     */
    public function get($customerId) {
        return $this->apiRequest("GET", "/customers/" . urlencode($customerId), NULL, NULL);
    }

    /**
     * @param array|stdClass $customer Object with customer fields for update
     *
     * Update customer
     *
     * @throws Voucherify\ClientException
     */
    public function update($customer) {
        $customerId = "";

        if (is_array($customer)) {
            $customerId = $customer['id'];
        } elseif (is_object($customer)) {
            $customerId = $customer->id;
        }

        return $this->apiRequest("PUT", "/customers/" . urlencode($customerId), NULL, $customer);
    }

    /**
     * @param $customerId Customer ID to delete
     *
     * Delete customer
     *
     * @throws Voucherify\ClientException
     */
    public function delete($customerId) {
        return $this->apiRequest("DELETE", "/customers/" . urlencode($customerId), NULL, NULL);
    }
}