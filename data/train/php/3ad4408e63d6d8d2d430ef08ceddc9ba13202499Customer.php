<?php
namespace Travel\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * Customers
 *
 * @ORM\Table(name="customers")
 * @ORM\Entity
 */
class Customer
{
    /**
     * @var integer
     *
     * @ORM\Column(name="customer_id", type="integer", nullable=false)
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="IDENTITY")
     */
    private $customerId;

    /**
     * @var string
     *
     * @ORM\Column(name="customer_firstname", type="string", length=100, nullable=true)
     */
    private $customerFirstname;

    /**
     * @var string
     *
     * @ORM\Column(name="customer_lastname", type="string", length=100, nullable=true)
     */
    private $customerLastname;

    /**
     * @var string
     *
     * @ORM\Column(name="customer_suburb", type="string", length=100, nullable=true)
     */
    private $customerSuburb;

    /**
     * @var string
     *
     * @ORM\Column(name="customer_comments", type="string", length=150, nullable=true)
     */
    private $customerComments;

    /**
     * @var integer
     *
     * @ORM\Column(name="customer_created", type="integer", nullable=false)
     */
    private $customerCreated;

	/**
	 * @return the $customerId
	 */
	public function getCustomerId() {
		return $this->customerId;
	}

	/**
	 * @param number $customerId
	 */
	public function setCustomerId($customerId) {
		$this->customerId = $customerId;
	}

	/**
	 * @return the $customerFirstname
	 */
	public function getCustomerFirstname() {
		return $this->customerFirstname;
	}

	/**
	 * @param string $customerFirstname
	 */
	public function setCustomerFirstname($customerFirstname) {
		$this->customerFirstname = $customerFirstname;
	}

	/**
	 * @return the $customerLastname
	 */
	public function getCustomerLastname() {
		return $this->customerLastname;
	}

	/**
	 * @param string $customerLastname
	 */
	public function setCustomerLastname($customerLastname) {
		$this->customerLastname = $customerLastname;
	}

	/**
	 * @return the $customerSuburb
	 */
	public function getCustomerSuburb() {
		return $this->customerSuburb;
	}

	/**
	 * @param string $customerSuburb
	 */
	public function setCustomerSuburb($customerSuburb) {
		$this->customerSuburb = $customerSuburb;
	}

	/**
	 * @return the $customerComments
	 */
	public function getCustomerComments() {
		return $this->customerComments;
	}

	/**
	 * @param string $customerComments
	 */
	public function setCustomerComments($customerComments) {
		$this->customerComments = $customerComments;
	}

	/**
	 * @return the $customerCreated
	 */
	public function getCustomerCreated() {
		return $this->customerCreated;
	}

	/**
	 * @param number $customerCreated
	 */
	public function setCustomerCreated($customerCreated) {
		$this->customerCreated = $customerCreated;
	}
}