<?php
namespace Dandomain\Api\Endpoint;

use GuzzleHttp\Psr7\Response;

class Customer extends Endpoint {
    /**
     * @param int $customerId
     * @return Response
     */
    public function getCustomer($customerId) {
        $this->assertInteger($customerId, '$customerId');

        return $this->getMaster()->call(
            'GET',
            sprintf(
                '/admin/WEBAPI/Endpoints/v1_0/CustomerService/{KEY}/%d',
                $customerId
            )
        );
    }

    /**
     * @param string $email
     * @return Response
     */
    public function getCustomerByEmail($email) {
        $this->assertString($email, '$email');

        return $this->getMaster()->call(
            'GET',
            sprintf(
                '/admin/WEBAPI/Endpoints/v1_0/CustomerService/{KEY}/GetCustomerByEmail?email=%s',
                rawurlencode($email)
            )
        );
    }

    /**
     * @param array $customer
     * @return Response
     */
    public function createCustomer($customer) {
        $this->assertArray($customer, '$customer');

        return $this->getMaster()->call(
            'POST',
            '/admin/WEBAPI/Endpoints/v1_0/CustomerService/{KEY}',
            ['json' => $customer]
        );
    }

    /**
     * @param int $customerId
     * @param array $customer
     * @return Response
     */
    public function updateCustomer($customerId, $customer) {
        $this->assertInteger($customerId, '$customerId');
        $this->assertArray($customer, '$customer');

        return $this->getMaster()->call(
            'PUT',
            sprintf(
                '/admin/WEBAPI/Endpoints/v1_0/CustomerService/{KEY}/%d',
                $customerId
            ),
            ['json' => $customer]
        );
    }

    /**
     * @param int $customerId
     * @return Response
     */
    public function deleteCustomer($customerId) {
        $this->assertInteger($customerId, '$customerId');

        return $this->getMaster()->call(
            'DELETE',
            sprintf(
                '/admin/WEBAPI/Endpoints/v1_0/CustomerService/{KEY}/%d',
                $customerId
            )
        );
    }

    /**
     * @return Response
     */
    public function getCustomerGroups() {
        return $this->getMaster()->call(
            'GET',
            '/admin/WEBAPI/Endpoints/v1_0/CustomerService/{KEY}/CustomerGroup'
        );
    }

    /**
     * @param int $customerId
     * @param array $customerDiscount
     * @return Response
     */
    public function updateCustomerDiscount($customerId, $customerDiscount) {
        $this->assertInteger($customerId, '$customerId');
        $this->assertArray($customerDiscount, '$customerDiscount');

        return $this->getMaster()->call(
            'POST',
            sprintf(
                '/admin/WEBAPI/Endpoints/v1_0/CustomerService/{KEY}/UpdateCustomerDiscount/%d',
                $customerId
            ),
            ['json' => $customerDiscount]
        );
    }

    /**
     * @param int $customerId
     * @return Response
     */
    public function getCustomerDiscount($customerId) {
        $this->assertInteger($customerId, '$customerId');

        return $this->getMaster()->call(
            'GET',
            sprintf(
                '/admin/WEBAPI/Endpoints/v1_0/CustomerService/{KEY}/GetCustomerDiscount/%d',
                $customerId
            )
        );
    }
}