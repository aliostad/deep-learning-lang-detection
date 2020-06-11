<?php

/**
 * @package burza.grk.cz
 * @author Milan Felix Sulc <sulcmil@gmail.com>
 * @version $$REV$$
 */

namespace App\Model\ORM;

use App\Model\ORM\Repository\BooksRepository;
use App\Model\ORM\Repository\CategoriesRepository;
use App\Model\ORM\Repository\ImagesRepository;
use App\Model\ORM\Repository\MessagesRepository;
use App\Model\ORM\Repository\UsersRepository;
use Nextras\Orm\Model\Model;

/**
 * @property-read UsersRepository $users
 * @property-read CategoriesRepository $categories
 * @property-read BooksRepository $books
 * @property-read ImagesRepository $images
 * @property-read MessagesRepository $messages
 */
final class Orm extends Model
{
}
