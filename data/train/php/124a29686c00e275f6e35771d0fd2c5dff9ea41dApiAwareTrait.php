<?php
namespace Packaged\Api\Traits;

use Packaged\Api\Interfaces\ApiInterface;

trait ApiAwareTrait
{
  /**
   * @var ApiInterface
   */
  protected $_api;

  /**
   * Set the API for this class
   *
   * @param ApiInterface $api
   *
   * @return static
   */
  public function setApi(ApiInterface $api)
  {
    $this->_api = $api;
    return $this;
  }

  /**
   * Retrieve the API from this class
   *
   * @return ApiInterface
   *
   * @throws \RuntimeException
   */
  public function getApi()
  {
    if($this->_api === null)
    {
      throw new \RuntimeException(
        "No API has been bound to " . get_called_class()
      );
    }
    return $this->_api;
  }
}
