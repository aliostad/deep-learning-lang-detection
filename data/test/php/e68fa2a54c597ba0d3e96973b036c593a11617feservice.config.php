<?php

use Application\Service\ArticleService;
use Application\Service\BankService;
use Application\Service\CompanyService;
use Application\Service\CustomerService;
use Application\Service\MailService;
use Application\Service\SmtpService;
use Application\Service\TemplateService;
use Application\Service\UomService;
use Application\Service\VatService;
use DoctrineModule\Persistence\ObjectManagerAwareInterface;
use Zend\I18n\Translator\TranslatorAwareInterface;
use Application\Service\LanguageService;
use Zend\ServiceManager\ServiceManager;

return array(
    'abstract_factories' => array(
        'Zend\Cache\Service\StorageCacheAbstractServiceFactory',
        'Zend\Log\LoggerAbstractServiceFactory',
    ),
    'aliases' => array(
        'translator' => 'MvcTranslator',
    ),
    'factories' => array(
        'Application\Service\Article' => function (ServiceManager $sm) {
            $service = new ArticleService();
            return $service;
        },
        'Application\Service\Bank' => function (ServiceManager $sm) {
            $service = new BankService();
            return $service;
        },
        'Application\Service\Company' => function (ServiceManager $sm) {
            $service = new CompanyService();
            return $service;
        },
        'Application\Service\Customer' => function (ServiceManager $sm) {
            $service = new CustomerService();
            return $service;
        },
        'Application\Service\Language' => function (ServiceManager $sm) {
            $service = new LanguageService();
            $service->setTranslator($sm->get('Translator'));
            return $service;
        },
        'Application\Service\Mail' => function (ServiceManager $sm) {
            $service = new MailService();
            return $service;
        },
        'Application\Service\Smtp' => function (ServiceManager $sm) {
            $service = new SmtpService();
            $service->setTranslator($sm->get('Translator'));
            return $service;
        },
        'Application\Service\Template' => function (ServiceManager $sm) {
            $service = new TemplateService();
            return $service;
        },
        'Application\Service\Uom' => function (ServiceManager $sm) {
            $service = new UomService();
            return $service;
        },
        'Application\Service\Vat' => function (ServiceManager $sm) {
            $service = new VatService();
            return $service;
        },
        'sessionManager' => function (ServiceManager $sm) {
            $sessionManager = new \Zend\Session\SessionManager();
            $configuration = $sm->get('Config');
            if (isset($configuration['sessionConfiguration'])) {
                $sessionConfig = new \Zend\Session\Config\SessionConfig();
                if (isset($configuration['sessionConfiguration']['rememberMeSeconds'])) {
                    $sessionConfig->setRememberMeSeconds($configuration['sessionConfiguration']['rememberMeSeconds']);
                }
                if (isset($configuration['sessionConfiguration']['savePath'])) {
                    $target = $configuration['sessionConfiguration']['savePath'];
                    if ($target === true) {
                        $target = realpath(dirname($_SERVER['SCRIPT_FILENAME'])) . '/../data/session';
                    }
                    if (!file_exists($target)) {
                        mkdir($target);
                    }
                    $sessionConfig->setSavePath($target);

                }
                if (isset($configuration['sessionConfiguration']['options'])) {
                    $sessionConfig->setOptions($configuration['sessionConfiguration']['options']);
                }
                $sessionManager->setConfig($sessionConfig);
            }

            return $sessionManager;
        },
    ),
    'initializers' => array (
        function ($service, $sm) {
            if ($service instanceof TranslatorAwareInterface) {
                $service->setTranslator($sm->get('MvcTranslator'));
            }
            if ($service instanceof ObjectManagerAwareInterface) {
                $service->setObjectManager($sm->get('doctrine.entitymanager.orm_default'));
            }
        }
    ),
);