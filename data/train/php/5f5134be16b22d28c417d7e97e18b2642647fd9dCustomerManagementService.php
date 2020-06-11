<?php
namespace AppBundle\Service;
use AppBundle\Repository\CustomerRepository;
use Doctrine\ORM\EntityManager;
class CustomerManagementService
{
	private $customerRepo;
	private $em;
	function __construct( EntityManager $em)
	{
		//$this->container = $container;
		$this->em = $em;
		$this->customerRepo = new CustomerRepository($this->em);
	}

	public function addCustomer($customer)
	{
		$this->customerRepo->addCustomer($customer);
	}

	public function deleteCustomer($customer_id)
	{
		return $this->customerRepo->deleteCustomer($customer_id);
	}

	public function getCustomerById($customer_id)
	{
		return $this->customerRepo->getCustomerById($customer_id);
	}

	public function editCustomer($customer, $modifiedCustomer)
	{
		$this->customerRepo->editCustomer($customer, $modifiedCustomer);
	}

	public function getAllCustomer()
	{
		return $this->customerRepo->getAllCustomer();
	}

	public function getAllRestoTable()
	{
		return $this->customerRepo->getAllRestoTable();
	}
}

?>