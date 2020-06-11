<?php

namespace cellar\Repository;

use cellar\Entity\Customer;
use Doctrine\DBAL\Connection;

class CustomerRepository implements RepositoryInterface
{

    /**
     * @var  \Doctrine\DBAL\Connection
     * */

    protected $database;

    public function __construct(Connection $db)
    {
        $this->database = $db;
    }

    public function save($customer)
    {
        /**
         * @var \cellar\Entity\Customer $customer
         */

        $customerData = array
        (
            'customer_rut' => $customer->getCustomerRut(),
            'customer_name' => $customer->getCustomerName(),
            'customer_lastname' => $customer->getCustomerLastname(),
            'customer_motherslastname' => $customer->getCustomerMotherslastname(),
            'customer_address' => $customer->getCustomerAddress()

        );

        if ($customer->getId()) {
            $this->database->update('customer', $customerData, array('id' => $customer->getId()));

        } else {
            $this->database->insert('customer', $customerData);
            $id = $this->database->lastInsertId();
            $customer->setId($id);
        }

        return $customer;
    }

    /**
     * Retorna el total de usuarios existentes en la base de datos.
     * @return integer The total number of customer.
     */

    public function getCount()
    {
        return $this->database->fetchColumn('SELECT COUNT(id) FROM customer');
    }

    /**
     * Retorna un id de usuario, que coincida con el id suministrado.
     * @param integer $id
     * @return \cellar\Entity\Customer|false Un objeto de entidad si se encuentra, false en caso contrario.
     */
    public function find($id)
    {
        $customerData = $this->database->fetchAssoc('SELECT * FROM customer WHERE id = ?', array($id));
        return $customerData ? $this->buildCustomer($customerData) : FALSE;
    }

    /**
     * Devuelve una colección de usuarios.
     * @param integer $limit
     *   El número de usuarios para volver.
     * @param integer $offset
     *   El número de usuarios para saltar.
     * @param array $orderBy
     *   Opcionalmente, el orden de información, en el $column => $direction format.
     * @return array A collection of customer, keyed by customer id.
     */
    public function findAll($limit, $offset = 1, $orderBy = array())
    {
        if (!$orderBy) {
            $orderBy = array('id' => 'ASC');
        }
        $queryBuilder = $this->database->createQueryBuilder();
        $queryBuilder
            ->select('c.*')
            ->from('customer', 'c')
            ->setMaxResults($limit)
            ->setFirstResult($offset)
            ->orderBy('c.' . key($orderBy), current($orderBy));
        $statement = $queryBuilder->execute();

        $customersData = $statement->fetchAll();
        $customers = array();

        foreach ($customersData as $customerData) {
            $customerId = $customerData['id'];
            $customers[$customerId] = $this->buildCustomer($customerData);
        }
        return $customers;
    }

    /**
     * @param integer $id
     * @return int
     */
    public function delete($id)
    {
        return $this->database->delete('customer', array('id' => $id));
    }

    /**
     * Ejemplariza una entidad usuario, establece sus propiedades utilizando datos db.
     * @param array $customerData The array of db data.
     * @return \cellar\Entity\Customer $customer
     */
    protected function buildCustomer($customerData)
    {
        $customer = new Customer();
        $customer->setId($customerData['id']);
        $customer->setCustomerRut($customerData['customer_rut']);
        $customer->setCustomerName($customerData['customer_name']);
        $customer->setCustomerLastname($customerData['customer_lastname']);
        $customer->setCustomerMotherslastname($customerData['customer_motherslastname']);
        $customer->setCustomerAddress($customerData['customer_address']);
        return $customer;

    }
}