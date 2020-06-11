<?php namespace App\Http\Controllers;

use App\Customer;
use App\CustomerGroup;

class CustomerController extends Controller
{
    protected $customer;

    function __construct(Customer $customer)
    {
        $this->customer = $customer;
    }

    public function editCustomer($customerId)
    {
        $customer = Customer::findOrFail($customerId);
        $groups = ['' => ''] + CustomerGroup::lists('groupname', 'id');

        return view('customer.edit')
            ->with('customer', $customer)
            ->with('groups', $groups)
            ->withBody('customer-edit');
    }

    public function removeCustomer($customerId)
    {
        $customer = Customer::findOrFail($customerId);
        $customer->delete();

        return \Redirect::to('/customers');
    }

    public function showCustomer($customerId)
    {
        $customer = Customer::findOrFail($customerId);

        return view('customer/show-customer')->with('customer', $customer);
    }

    public function showCustomers()
    {
        return view('customer.index')
            ->with('body', 'customers');
    }

    public function showCustomersOf($groupId)
    {
        $group = CustomerGroup::findOrFail($groupId);

        return view('customer.show-customers-of')
            ->with('group', $group)
            ->with('body', 'customers-of-'.$groupId);
    }

    public function showCustomerForm()
    {
        $groups = ['' => ''] + CustomerGroup::lists('groupname', 'id');

        return view('customer/create')
            ->with('groups', $groups)
            ->withBody('customer-edit');
    }

    public function saveCustomer($customerId)
    {
        $customer = Customer::findOrFail($customerId);
        $input = \Input::all();
        $customer->fill($input);
        if (!$customer->save()) {
            return \Redirect::route('customers.edit', $customerId)
                           ->withErrors($customer->getErrors())
                           ->withInput();
        }

        return \Redirect::to('/customers');
    }

    public function createCustomer()
    {
        $input = \Input::only('firstname', 'lastname', 'phone', 'group_id');

        $customer = $this->customer->fill($input);
        if (!$customer->save()) {
            return \Redirect::route('customers.addForm')
                ->withErrors($customer->getErrors())
                ->withInput();
        }

        return \Redirect::to('/customers');
    }

    public function table()
    {
        $operations = [
            '<li>{!!link_to_route("customers.edit", "edit", ["customerId" => $id], ["class" => "glyphicon glyphicon-pencil"])!!}</li>',
            '<li>{!!link_to_route("customers.remove", "remove", ["customerId" => $id], ["class" => "glyphicon glyphicon-remove"])!!}</li>',
        ];

        $customers = Customer::leftJoin('customer_group', 'customer.group_id', '=', 'customer_group.id')
            ->select([
                'customer.id',
                'customer.firstname',
                'customer.lastname',
                'customer.phone',
                'customer_group.groupname',
            ]);

        return \Datatables::of($customers)
            ->add_column('operations', '<ul class="operations">' . implode($operations) . '</ul>')
            ->add_column('show', '{{route("customers.show", ["customerId" => $id])}}')
            ->remove_column('id')
            ->make(true);
    }
} 