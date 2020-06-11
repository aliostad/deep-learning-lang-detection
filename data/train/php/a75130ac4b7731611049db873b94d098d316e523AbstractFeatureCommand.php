<?php
namespace CASS\Domain\Bundles\Community\Middleware\Command\Feature;

use CASS\Application\Command\Command;
use CASS\Domain\Bundles\Community\Service\CommunityFeaturesService;
use CASS\Domain\Bundles\Community\Service\CommunityService;

abstract class AbstractFeatureCommand implements Command
{
    /** @var CommunityService */
    protected $communityService;

    /** @var CommunityFeaturesService */
    protected $communityFeatureService;

    public function __construct(
        CommunityService $communityService,
        CommunityFeaturesService $communityFeatureService
    ) {
        $this->communityService = $communityService;
        $this->communityFeatureService = $communityFeatureService;
    }
}