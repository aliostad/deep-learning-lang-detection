<?php

namespace Nokaut\ApiClient;

use Guzzle\Http\ClientInterface;
use Nokaut\ApiClient\Repository\InvoiceRepository,
    Nokaut\ApiClient\Repository\ShippingRepository,
    Nokaut\ApiClient\Repository\StatusRepository,
    Nokaut\ApiClient\Repository\OrdersRepository;

/**
 * RepositoryManager
 *
 * @package Manager
 * @author Patryk Szlagowski <patryk.szlagowski@nokaut.pl>
 */
class RepositoryManager
{

    /**
     * @var \Guzzle\Http\ClientInterface
     */
    private $client;

    /**
     * @param \Guzzle\Http\ClientInterface $client
     */
    public function __construct(ClientInterface $client)
    {
        $this->client = $client;
    }

    /**
     * Get status repository
     *
     * @return \Nokaut\ApiClient\Repository\StatusRepository
     */
    public function getStatusRepository()
    {
        return new StatusRepository($this->client);
    }

    /**
     * get orders repository
     *
     * @return \Nokaut\ApiClient\Repository\OrdersRepository
     */
    public function getOrdersRepository()
    {
        return new OrdersRepository($this->client);
    }

    /**
     * get invoice repository
     *
     * @return InvoiceRepository
     */
    public function getInvoiceRepository()
    {
        return new InvoiceRepository($this->client);
    }

    /**
     * get shipping repository
     *
     * @return ShippingRepository
     */
    public function getShippingRepository()
    {
        return new ShippingRepository($this->client);
    }
}