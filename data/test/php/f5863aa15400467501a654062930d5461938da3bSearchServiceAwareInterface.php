<?php

namespace ArpSearch\Service;

/**
 * SearchServiceInterface
 *
 * @author Alex Patterson <alex.patterson.webdev@gmail.com>
 */
interface SearchServiceAwareInterface
{
    /**
     * getSearchService
     *
     * Return the search service.
     *
     * @return  SearchServiceInterface
     */
    public function getSearchService();

    /**
     * setSearchService
     *
     * Set the search service instance.
     *
     * @param SearchServiceInterface  $searchService  The search service.
     *
     * @return $this
     */
    public function setSearchService(SearchServiceInterface $searchService);

}