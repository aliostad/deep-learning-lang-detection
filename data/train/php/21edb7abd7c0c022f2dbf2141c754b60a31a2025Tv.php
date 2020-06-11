<?php namespace Merahputih\Tv;

/**
 * Tv
 *
 * NOTICE OF LICENSE
 *
 * Licensed under the MIT License.
 *
 * This source file is subject to the MIT License that is
 * bundled with this package in the LICENSE file.  It is also available at
 * the following URL: http://opensource.org/licenses/MIT
 *
 * @package    Tv
 * @version    1.0.0
 * @author     Abdul Hafidz A <aditans88@gmail.com>
 * @license    MIT License
 */

use Merahputih\Tv\Repositories\TvRepositoryInterface;

class Tv 
{
	/**
     * Video repository.
     *
     * @var VideoRepositoryInterface
     */
    protected $repository;

	/**
     * Create a new Order object.
     *
     * @param  VideoRepositoryInterface $repository
     * @param  integer $ownerId
     *
     * @return void
     */
    public function __construct(
        TvRepositoryInterface $repository
    )
    {
        $this->repository     = $repository;
    }

    /**
     * Set order repository
     *
     * @param  VideoRepositoryInterface $repository
     *
     * @return void
     */
    public function setRepository(TvRepositoryInterface $repository)
    {
        $this->repository = $repository;
    }

    /**
     * Return the order repository
     *
     * @return UploadRepositoryInterface
     */
    public function getRepository()
    {
        return $this->repository;
    }

    

}