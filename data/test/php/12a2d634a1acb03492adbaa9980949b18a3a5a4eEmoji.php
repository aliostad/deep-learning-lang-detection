<?php
namespace EmojiModule\View\Helper;

use EmojiModule\Service\Emoji as EmojiService;
use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\View\Helper\AbstractHelper;

class Emoji extends AbstractHelper implements ServiceLocatorAwareInterface
{
    /**
     * @var EmojiService
     */
    protected $emojiService;

    public function __invoke()
    {
        return $this->getEmojiService();
    }

    public function getEmojiService()
    {
        if (!$this->emojiService instanceof EmojiService) {
            $viewPluginManager = $this->getServiceLocator();
            $this->setEmojiService($viewPluginManager->getServiceLocator()->get('emojimodule_emoji_service'));
        }
        return $this->emojiService;
    }


    /**
     * Set emoji service
     *
     * @param  EmojiService $emojiService
     * @return Emoji
     */
    public function setEmojiService(EmojiService $emojiService)
    {
        $this->emojiService = $emojiService;
        return $this;
    }


    /**
     * Set service locator
     *
     * @param ServiceLocatorInterface $serviceLocator
     */
    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->serviceLocator = $serviceLocator;
    }

    /**
     * Get service locator
     *
     * @return ServiceLocatorInterface
     */
    public function getServiceLocator()
    {
        return $this->serviceLocator;
    }
}
