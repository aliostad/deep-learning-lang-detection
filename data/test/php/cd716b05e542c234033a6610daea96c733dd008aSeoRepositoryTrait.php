<?php

namespace EnliteSeo\Repository;

use EnliteSeo\Repository\SeoRepository;

trait SeoRepositoryTrait
{

    /**
     * @var SeoRepository
     */
    protected $seoRepository = null;

    /**
     * @param SeoRepository $seoRepository
     */
    public function setSeoRepository(SeoRepository $seoRepository)
    {
        $this->seoRepository = $seoRepository;
    }

    /**
     * @return SeoRepository
     */
    public function getSeoRepository()
    {
        if (null === $this->seoRepository) {
            $this->seoRepository = $this->getEntityManager()->getRepository(
                $this->getGlobalOptions()->getEntity()
            );
        }
        return $this->seoRepository;
    }


}
