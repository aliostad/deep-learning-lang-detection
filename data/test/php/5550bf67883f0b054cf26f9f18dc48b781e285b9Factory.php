<?php
/**
 * MITHrIL: miRNA enriched pathway impact analysis
 * REST Web Service
 *
 * @author S. Alaimo (alaimos at dmi.unict.it)
 */

namespace Mithril\Pathway\Repository;

/**
 * Class Repository Factory
 *
 * @method static \Mithril\Pathway\Repository\Factory getInstance()
 * @package Mithril\Pathway\Repository
 */
class Factory
{

    use \Mithril\Data\SingletonTrait;

    protected $repositories = [];

    /**
     * @param string $what
     *
     * @return boolean
     */
    protected function initRepository($what)
    {
        if (!isset($this->repositories[$what])) {
            $this->repositories[$what] = new $what();
            return false;
        }
        return true;
    }

    /**
     * Get entries repository
     *
     * @return \Mithril\Pathway\Repository\Entry\Entry
     */
    public function getEntriesRepository()
    {
        if (!$this->initRepository('\Mithril\Pathway\Repository\Entry\Entry')) {
            /** @var \Mithril\Pathway\Repository\Entry\Entry $repo */
            $repo = $this->repositories['\Mithril\Pathway\Repository\Entry\Entry'];
            $repo->setRelationsRepository($this->getRelationsRepository());
        }
        return $this->repositories['\Mithril\Pathway\Repository\Entry\Entry'];
    }

    /**
     * Get relations repository
     *
     * @return \Mithril\Pathway\Repository\Relation\Relation
     */
    public function getRelationsRepository()
    {
        $this->initRepository('\Mithril\Pathway\Repository\Relation\Relation');
        return $this->repositories['\Mithril\Pathway\Repository\Relation\Relation'];
    }

    /**
     * Get pathways repository
     *
     * @return \Mithril\Pathway\Repository\Pathway
     */
    public function getPathwaysRepository()
    {
        if (!$this->initRepository('\Mithril\Pathway\Repository\Pathway')) {
            /** @var \Mithril\Pathway\Pathway $repo */
            $repo = $this->repositories['\Mithril\Pathway\Repository\Pathway'];
            $repo->setEntriesRepository($this->getEntriesRepository())
                ->setRelationsRepository($this->getRelationsRepository());
        }
        return $this->repositories['\Mithril\Pathway\Repository\Pathway'];
    }

    /**
     * Get entry types repository
     *
     * @return \Mithril\Pathway\Repository\Entry\Type
     */
    public function getEntryTypesRepository()
    {
        $this->initRepository('\Mithril\Pathway\Repository\Entry\Type');
        return $this->repositories['\Mithril\Pathway\Repository\Entry\Type'];
    }

    /**
     * Get relation types repository
     *
     * @return \Mithril\Pathway\Repository\Relation\Type
     */
    public function getRelationTypesRepository()
    {
        $this->initRepository('\Mithril\Pathway\Repository\Relation\Type');
        return $this->repositories['\Mithril\Pathway\Repository\Relation\Type'];
    }

    /**
     * Get relation sub-types repository
     *
     * @return \Mithril\Pathway\Repository\Relation\SubType
     */
    public function getRelationSubTypesRepository()
    {
        $this->initRepository('\Mithril\Pathway\Repository\Relation\SubType');
        return $this->repositories['\Mithril\Pathway\Repository\Relation\SubType'];
    }

}