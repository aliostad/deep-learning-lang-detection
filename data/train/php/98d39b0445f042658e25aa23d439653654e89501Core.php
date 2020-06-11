<?php
namespace STS;

use STS\Core\Api\DefaultAuthFacade;
use STS\Core\Api\DefaultProfessionalGroupFacade;
use STS\Core\Api\DefaultSchoolFacade;
use STS\Core\Api\DefaultMemberFacade;
use STS\Core\Api\DefaultSurveyFacade;
use STS\Core\Api\DefaultPresentationFacade;
use STS\Core\Api\DefaultLocationFacade;
use STS\Core\Api\DefaultUserFacade;
use STS\Core\Api\DefaultMailerFacade;
use STS\Core\Cache;
use STS\Core\DbFactory;
use STS\Core\MongoFactory;
use Symfony\Component\DependencyInjection\Tests\Compiler\C;

class Core
{
    const CORE_CONFIG_PATH = '/config/core.xml';

    private $config;
    private $dbFactory;
    private $cache;

    protected static $default;

    public function __construct(\Zend_Config $config, DbFactory $factory, Cache $cache)
    {
        $this->config = $config;
        $this->dbFactory = $factory;
        $this->cache = $cache;
    }
    public function load($key)
    {
        $db = $this->dbFactory->getDb($this->config);
        $cache = $this->cache;

        switch ($key) {
            case 'AuthFacade':
                $facade = DefaultAuthFacade::getDefaultInstance($db);
                break;
            case 'SchoolFacade':
                $facade = DefaultSchoolFacade::getDefaultInstance($db,$cache);
                break;
            case 'MemberFacade':
                $facade = DefaultMemberFacade::getDefaultInstance($db, $cache);
                break;
            case 'SurveyFacade':
                $facade = DefaultSurveyFacade::getDefaultInstance($db);
                break;
            case 'PresentationFacade':
                $facade = DefaultPresentationFacade::getDefaultInstance($db, $cache);
                break;
            case 'LocationFacade':
                $facade = DefaultLocationFacade::getDefaultInstance($db);
                break;
            case 'UserFacade':
                $facade = DefaultUserFacade::getDefaultInstance($db);
                break;
            case 'MailerFacade':
                $facade = DefaultMailerFacade::getDefaultInstance($this->config);
                break;
            case 'ProfessionalGroupFacade':
                $facade = DefaultProfessionalGroupFacade::getDefaultInstance($db);
                break;
            default:
                throw new \InvalidArgumentException("Class does not exist ($key)");
        }
        return $facade;
    }

    /**
     * @return \Zend_Config
     */
    public function getConfig()
    {
        return $this->config;
    }

    /**
     * getDefaultInstance
     *
     * @return Core
     */
    public static function getDefaultInstance()
    {
        if (!isset(self::$default)) {
            $configPath = APPLICATION_PATH . self::CORE_CONFIG_PATH;
            $config = new \Zend_Config_Xml($configPath, 'all');
            $factory = new MongoFactory();
            $cache = new Cache();
            self::$default = new Core($config, $factory, $cache);
        }

        return self::$default;
    }
}
