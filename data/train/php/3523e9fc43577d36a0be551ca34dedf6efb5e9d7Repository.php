<?php

/**
 *
 * @copyright Copyright (c) 2013-2016 KipsProduction (http://www.kips.gr.jp)
 * @license   http://www.kips.gr.jp/newbsd/LICENSE.txt New BSD License
 */

namespace NpDocument\Model\Document\Service;

/**
 * DocumentRepositoryへのアクセスを提供する
 *
 * @author Tomoaki Kosugi <kosugi at kips.gr.jp>
 */
class Repository extends AbstractService
{

    protected $repository;

    public function setRepository($repository)
    {
        $this->repository = $repository;
    }

    public function getRepository()
    {
        return $this->repository;
    }
}
