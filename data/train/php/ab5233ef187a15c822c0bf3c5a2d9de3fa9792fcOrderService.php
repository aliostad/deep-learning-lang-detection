<?php

namespace CodeDelivery\Services;

use CodeDelivery\Repositories\OrderRepository;
use CodeDelivery\Repositories\CupomRepository;
use CodeDelivery\Repositories\ProductRepository;

class OrderService
{
    private $orderRepository;
    private $cupomRepository;
    private $productRepository;

    public function __construct(
        OrderRepository $orderRepository,
        CupomRepository $cupomRepository,
        ProductRepository $productRepository){

        $this->orderRepository = $orderRepository;
        $this->cupomRepository = $cupomRepository;
        $this->productRepository = $productRepository;
    }

    public function create(array $data){
        \DB::beginTransaction();
        try {
            $data['status'] = 0;
            if(isset($data['cupom_code'])){
                $cupom = $this->cupomRepository->findByField('code', $data['cupom_code'])->first();
                $data['cupom_id'] = $cupom->id;
                $cupom->used = 1;
                $cupom->save();
                unset($data['cupom_code']);
            }

            $items = $data['items'];
            unset($data['items']);

            $order = $this->orderRepository->create($data);
            $total = 0;
            foreach($items as $item){
                $item['price'] =  $this->productRepository->find($item['product_id'])->price;
                $order->items()->create($item);
                $total += $item['price'] * $item['qtd'];
            }

            $order->total = $total;
            if(isset($cupom)){
                $order->total = $total - $cupom->value;
            }
            $order->save();
            \DB::commit();

        } catch(\Exception $e) {
            \DB::rollback();
            throw $e;
        }
    }

}
