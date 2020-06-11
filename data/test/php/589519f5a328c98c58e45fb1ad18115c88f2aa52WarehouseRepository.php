<?php

namespace Extension\Shop\Repository;

use BinCMS\RepositoryTrait\RepositoryExtendTrait;
use BinCMS\RepositoryTrait\RepositoryExternalTrait;
use BinCMS\RepositoryTrait\RepositoryFilteredTrait;
use Doctrine\ODM\MongoDB\DocumentRepository;
use Extension\Shop\Repository\Interfaces\WarehouseRepositoryInterface;
use Extension\Shop\Repository\Traits\DocumentRepositoryCounted;

class WarehouseRepository extends DocumentRepository implements \Countable, WarehouseRepositoryInterface
{
    use RepositoryExtendTrait;
    use DocumentRepositoryCounted;
    use RepositoryFilteredTrait;
    use RepositoryExternalTrait;
}