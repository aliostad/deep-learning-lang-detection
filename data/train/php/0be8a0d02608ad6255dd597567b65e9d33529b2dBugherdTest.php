<?php

namespace Onwwward\Bugherd\Tests\Facades;

use Bugherd\Client;
use GrahamCampbell\TestBenchCore\FacadeTrait;
use Onwwward\Bugherd\Facades\Bugherd;
use Onwwward\Bugherd\Tests\AbstractTestCase;

class BugherdTest extends AbstractTestCase
{
    use FacadeTrait;

  /**
   * Get the facade accessor.
   *
   * @return string
   */
  protected function getFacadeAccessor()
  {
      return 'bugherd';
  }

  /**
   * Get the facade class.
   *
   * @return string
   */
  protected function getFacadeClass()
  {
      return Bugherd::class;
  }

  /**
   * Get the facade root.
   *
   * @return string
   */
  protected function getFacadeRoot()
  {
      return Client::class;
  }
}
