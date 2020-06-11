<?php

namespace Dojo;

class AffiliateService
{
    /**
     * @var AffiliateRepository
     */
    private $repository;

    public function __construct(AffiliateRepository $repository)
    {
        $this->repository = $repository;
    }

    public function createAffiliate($data)
    {
        $this->repository->create($data);
    }

    /**
     * @param $affiliateId
     * @return Affiliate
     */
    public function retrieveAffiliate($affiliateId)
    {
        return $this->repository->retrieveByAffiliateId($affiliateId);
    }

    /**
     * @param Affiliate $affiliate
     */
    public function updateAffiliate(Affiliate $affiliate)
    {
        $this->repository->update($affiliate);
    }

    public function deleteAffiliate($affiliateId)
    {
        $this->repository->delete($affiliateId);
    }

    public function listAffiliates()
    {
        $this->repository->index();
    }
}
