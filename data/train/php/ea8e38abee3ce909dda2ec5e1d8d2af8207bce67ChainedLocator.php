<?php
namespace CCM\LocatorBundle\Locator;


class ChainedLocator implements LocatorInterface
{
    private $locators;

    public function addLocator(LocatorInterface $locator)
    {
        $this->locators[] = $locator;
    }

    /**
     * @param $query
     */
    public function searchByKeyword($query)
    {
        $results = array();

        foreach ($this->locators as $locator)
        {
            $results = array_merge($locator->searchByKeyword($query));
        }
        return $results;
    }

}