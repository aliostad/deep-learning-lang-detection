<?php namespace Pantono\Suppliers;

use Pantono\Suppliers\Entity\Repository\SuppliersRepository;

class Suppliers
{
    private $repository;

    public function __construct(SuppliersRepository $repository)
    {
        $this->repository = $repository;
    }

    public function getSupplierList()
    {
        $list = [];
        $suppliers = $this->repository->getSupplierList();
        foreach ($suppliers as $supplier) {
            $list[$supplier->getId()] = $supplier->getCompanyName();
        }
        return $list;
    }
}
