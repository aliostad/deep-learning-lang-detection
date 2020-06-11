<?php
namespace thewulf7\friendloc\components;


use thewulf7\friendloc\services\
{
    AuthService, UserService, EmailService, MapService, SearchService
};

/**
 * Class AbstractService
 *
 * @package thewulf7\friendloc\components
 *
 * @method \thewulf7\friendloc\services\AuthService getAuthService()
 * @method \thewulf7\friendloc\services\EmailService getEmailService()
 * @method \thewulf7\friendloc\services\UserService getUserService()
 * @method \thewulf7\friendloc\services\MapService getMapService()
 * @method \thewulf7\friendloc\services\SearchService getSearchService()
 */
abstract class AbstractService
{
    use ApplicationHelper;
}