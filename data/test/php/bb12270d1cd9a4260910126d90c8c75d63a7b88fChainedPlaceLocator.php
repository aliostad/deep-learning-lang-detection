<?php

namespace MSB\LocatorBundle\Places;

/**
 * ChainedPlaceLocator searches for places into registered implementations of PlaceLocatorInterface
 */
class ChainedPlaceLocator implements PlaceLocatorInterface
{
    private $locators = [];

    /**
     * Registers a new implementation of PlaceLocatorInterface
     *
     * @param PlaceLocatorInterface $locator
     */
    public function addLocator(PlaceLocatorInterface $locator)
    {
        $this->locators[] = $locator;
    }

    public function searchByKeyword($query)
    {
        $results = [];

        // for each implementations...
        foreach ($this->locators as $locator) {
            // ...merge its results
            $results = array_merge($results, $locator->searchByKeyword($query));
        }

        return $results;
    }
}
