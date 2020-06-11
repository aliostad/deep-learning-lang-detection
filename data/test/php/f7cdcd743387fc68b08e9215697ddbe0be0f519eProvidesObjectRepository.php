<?php
/**
 * CoolMS2 Doctrine Common Library (http://www.coolms.com/)
 *
 * @link      http://github.com/coolms/doctrine for the canonical source repository
 * @copyright Copyright (c) 2006-2015 Altgraphic, ALC (http://www.altgraphic.com)
 * @license   http://www.coolms.com/license/new-bsd New BSD License
 * @author    Dmitry Popov <d.popov@altgraphic.com>
 */

namespace CmsDoctrine\Persistence;

use Doctrine\Common\Persistence\ObjectRepository;

trait ProvidesObjectRepository
{
    /**
     * @var ObjectRepository
     */
    protected $objectRepository;

    /**
     * @return ObjectRepository
     */
    public function getObjectRepository()
    {
        return $this->objectRepository;
    }

    /**
     * @param ObjectRepository $objectRepository
     * @return self
     */
    public function setObjectRepository(ObjectRepository $objectRepository)
    {
        $this->objectRepository = $objectRepository;

        return $this;
    }
}
