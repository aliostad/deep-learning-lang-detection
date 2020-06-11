<?php
namespace Flagbit\FACTFinder\Model\Handler;

class Suggest
{
    /**
     * FACTFinder Facade
     *
     * @var \Flagbit\FACTFinder\Model\Facade
     */
    protected $_facade;

    /**
     * Query factory
     *
     * @var \Magento\Search\Model\QueryFactory
     */
    protected $_queryFactory;

    /**
     * @param \Flagbit\FACTFinder\Model\Facade   $facade
     * @param \Magento\Search\Model\QueryFactory $queryFactory
     */
    public function __construct(
        \Flagbit\FACTFinder\Model\Facade $facade,
        \Magento\Search\Model\QueryFactory $queryFactory
    ) {
        $this->_facade = $facade;
        $this->_queryFactory = $queryFactory;
        $this->_configureFacade();
    }

    protected function _configureFacade()
    {
        $this->_facade->configureSuggestAdapter([
            'query'             => $this->_queryFactory->get()->getQueryText(),
            'format'            => 'json',
            'idsOnly'           => 'true'
        ]);
    }

    public function getSuggestions()
    {
        return $this->_facade->getSuggestions();
    }
}