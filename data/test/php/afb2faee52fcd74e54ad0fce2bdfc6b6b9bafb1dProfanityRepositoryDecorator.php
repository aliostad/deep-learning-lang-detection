<?php
namespace OpenNotion\ProfanityFilter\Repository\Decorator;

use OpenNotion\ProfanityFilter\Repository\ProfanityRepositoryInterface;

/**
 * Base ProfanityRepository decorator class to be extended in order to add additional functionality to profanity repositories.
 *
 * @package OpenNotion\ProfanityFilter
 */
abstract class ProfanityRepositoryDecorator implements ProfanityRepositoryInterface
{
    /** @var \OpenNotion\ProfanityFilter\Repository\ProfanityRepositoryInterface $profanityRepository */
    protected $profanityRepository;

    public function __construct(ProfanityRepositoryInterface $profanityRepository)
    {
        $this->profanityRepository = $profanityRepository;
    }
} 
