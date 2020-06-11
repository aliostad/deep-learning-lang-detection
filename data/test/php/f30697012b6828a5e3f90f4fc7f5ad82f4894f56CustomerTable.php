<?php
namespace Formulaire_User\Model;

use Zend\Db\TableGateway\TableGateway;

class CustomerTable
{

    protected $tableGateway;

    public function __construct (TableGateway $tableGateway)
    {
        $this->tableGateway = $tableGateway;
    }

    public function fetchAll ()
    {
        $resultSet = $this->tableGateway->select();
        return $resultSet;
    }

    public function getCustomer ($customerId)
    {
        $customerId = (int) $customerId;
        $rowset = $this->tableGateway->select(array(
            'customer_id' => $customerId
        ));
        $row = $rowset->current();
        if (! $row) {
            throw new \Exception("Impossible de trouver l'utilisateur $customerId");
        }
        return $row;
    }

    public function saveCustomer (Customer $customer)
    {
        $data = array(
            'customer_name' => $customer->customer_name,
            'user_id'=>$customer->user_id,
            'customer_company_number' => $customer->customer_company_number,
            'customer_validate' => $customer->customer_validate,
            'customer_number' => $customer->customer_number,
            'customer_telephone' => $customer->customer_telephone,
            'customer_fax' => $customer->customer_fax,
            'customer_address' => $customer->customer_address,
            'customer_zipcode' => $customer->customer_zipcode,
            'customer_city' => $customer->customer_city,
            'customer_country' => $customer->customer_country,
            'customer_type' => $customer->customer_type,
            'customer_logo_path' => $customer->customer_logo_path,
            'customer_sponsoring_number' => $customer->customer_sponsoring_number,
            'customer_folder_path' => $customer->customer_folder_path,
           /*  'admin_id' => $customer->admin_id,
            'commercial_id' => $customer->commercial_id */
        );
        
        $customer_id = (int) $customer->customer_id;
        if ($customer_id == 0) {
            $this->tableGateway->insert($data);
        } else {
            if ($this->getCustomer($customer_id)) {
                $this->tableGateway->update($data, array(
                    'customer_id' => $customer_id
                ));
            } else {
                throw new \Exception('Le formulaire client customer_id n\'existe pas');
            }
        }
    }
    
    public function deleteCustomer ($customer_id)
    {
    	$this->tableGateway->delete(array(
    			'customer_id' => $customer_id
    	));
    }
}