<?php

namespace AvadoLearning\BusinessLogicServices\SalesLogixService;

class SaveLeadResponse
{

    /**
     * @var SaveLeadEntitiesSaveLeadResponse $SaveLeadResult
     */
    protected $SaveLeadResult = null;

    /**
     * @param SaveLeadEntitiesSaveLeadResponse $SaveLeadResult
     */
    public function __construct($SaveLeadResult)
    {
      $this->SaveLeadResult = $SaveLeadResult;
    }

    /**
     * @return SaveLeadEntitiesSaveLeadResponse
     */
    public function getSaveLeadResult()
    {
      return $this->SaveLeadResult;
    }

    /**
     * @param SaveLeadEntitiesSaveLeadResponse $SaveLeadResult
     * @return \AvadoLearning\BusinessLogicServices\SalesLogixService\SaveLeadResponse
     */
    public function setSaveLeadResult($SaveLeadResult)
    {
      $this->SaveLeadResult = $SaveLeadResult;
      return $this;
    }

}
