<?php

use App\Models\Customer;
use App\Repositories\CustomerRepository;
use Illuminate\Foundation\Testing\DatabaseTransactions;

class CustomerRepositoryTest extends TestCase
{
    use MakeCustomerTrait, ApiTestTrait, DatabaseTransactions;

    /**
     * @var CustomerRepository
     */
    protected $customerRepo;

    public function setUp()
    {
        parent::setUp();
        $this->customerRepo = App::make(CustomerRepository::class);
    }

    /**
     * @test create
     */
    public function testCreateCustomer()
    {
        $customer = $this->fakeCustomerData();
        $createdCustomer = $this->customerRepo->create($customer);
        $createdCustomer = $createdCustomer->toArray();
        $this->assertArrayHasKey('id', $createdCustomer);
        $this->assertNotNull($createdCustomer['id'], 'Created Customer must have id specified');
        $this->assertNotNull(Customer::find($createdCustomer['id']), 'Customer with given id must be in DB');
        $this->assertModelData($customer, $createdCustomer);
    }

    /**
     * @test read
     */
    public function testReadCustomer()
    {
        $customer = $this->makeCustomer();
        $dbCustomer = $this->customerRepo->find($customer->id);
        $dbCustomer = $dbCustomer->toArray();
        $this->assertModelData($customer->toArray(), $dbCustomer);
    }

    /**
     * @test update
     */
    public function testUpdateCustomer()
    {
        $customer = $this->makeCustomer();
        $fakeCustomer = $this->fakeCustomerData();
        $updatedCustomer = $this->customerRepo->update($fakeCustomer, $customer->id);
        $this->assertModelData($fakeCustomer, $updatedCustomer->toArray());
        $dbCustomer = $this->customerRepo->find($customer->id);
        $this->assertModelData($fakeCustomer, $dbCustomer->toArray());
    }

    /**
     * @test delete
     */
    public function testDeleteCustomer()
    {
        $customer = $this->makeCustomer();
        $resp = $this->customerRepo->delete($customer->id);
        $this->assertTrue($resp);
        $this->assertNull(Customer::find($customer->id), 'Customer should not exist in DB');
    }
}
