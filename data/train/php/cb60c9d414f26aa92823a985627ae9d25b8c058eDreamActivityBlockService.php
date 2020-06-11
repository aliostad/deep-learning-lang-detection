<?php

namespace Geekhub\DreamBundle\Block;

use Geekhub\DreamBundle\Repository\DreamRepository;
use Geekhub\DreamBundle\Repository\CommonRepository;
use Sonata\BlockBundle\Block\BaseBlockService;
use Sonata\BlockBundle\Block\BlockContextInterface;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\OptionsResolver\OptionsResolverInterface;
use Symfony\Component\Templating\EngineInterface;

class DreamActivityBlockService extends BaseBlockService
{
    /** @var  DreamRepository */
    protected $dreamRepository;

    /** @var  CommonRepository */
    protected $statusRepository;

    /** @var  CommonRepository */
    protected $financialRepository;

    /** @var  CommonRepository */
    protected $equipmentRepository;

    /** @var  CommonRepository */
    protected $workRepository;

    /** @var  CommonRepository */
    protected $otherRepository;

    /**
     * @param string $name
     * @param EngineInterface $templating
     * @param DreamRepository $dreamRepository
     * @param CommonRepository $statusRepository
     * @param CommonRepository $financialRepository
     * @param CommonRepository $equipmentRepository
     * @param CommonRepository $workRepository
     * @param CommonRepository $otherRepository
     */
    public function __construct($name,
                                EngineInterface $templating,
                                DreamRepository $dreamRepository,
                                CommonRepository $statusRepository,
                                CommonRepository $financialRepository,
                                CommonRepository $equipmentRepository,
                                CommonRepository $workRepository,
                                CommonRepository $otherRepository
    )
    {
        $this->name       = $name;
        $this->templating = $templating;
        $this->dreamRepository     = $dreamRepository;
        $this->statusRepository    = $statusRepository;
        $this->financialRepository = $financialRepository;
        $this->equipmentRepository = $equipmentRepository;
        $this->workRepository      = $workRepository;
        $this->otherRepository     = $otherRepository;
    }

    /**
     * {@inheritdoc}
     */
    public function execute(BlockContextInterface $blockContext, Response $response = null)
    {
        $settings = $blockContext->getSettings();
        $days = array_key_exists('days', $settings) ? $settings['days'] : 7;
        $to = new \DateTime();
        $from = new \DateTime(sprintf('-%s days', $days));

        $statuses = $this->statusRepository->findByPeriod($from, $to);
        $financialContributes = $this->financialRepository->findByPeriod($from, $to);
        $equipmentContributes = $this->equipmentRepository->findByPeriod($from, $to);
        $workContributes      = $this->workRepository->findByPeriod($from, $to);
        $otherContributes     = $this->otherRepository->findByPeriod($from, $to);

        $sortedEvents = $this->sortEventsByCreatedAt([$statuses, $financialContributes, $equipmentContributes, $workContributes, $otherContributes]);

        return $this->renderResponse($blockContext->getTemplate(), array(
            'block'     => $blockContext->getBlock(),
            'settings'  => $blockContext->getSettings(),
            'sortedEvents' => $sortedEvents,
        ), $response);
    }

    /**
     * {@inheritdoc}
     */
    public function getName()
    {
        return 'geekhub.dream.block.dream_activity';
    }

    /**
     * {@inheritdoc}
     */
    public function setDefaultSettings(OptionsResolverInterface $resolver)
    {
        $resolver->setDefaults(array(
            'content'  => 'Insert your custom content here',
            'template' => 'GeekhubDreamBundle:Block:block_dream_activity.html.twig'
        ));
    }

    protected function sortEventsByCreatedAt(array $events)
    {
        $mergedEvents = call_user_func_array('array_merge', $events);
        usort($mergedEvents, [$this, 'sortedByCreatedAt']);

        $sortedEvents = array();

        foreach ($mergedEvents as $object) {
            $sortedEvents[$object->getCreatedAt()->format('Y-m-d')][] = $object;
        }

        return $sortedEvents;
    }

    public static function sortedByCreatedAt($object1, $object2)
    {
        if ($object1->getCreatedAt() == $object2->getCreatedAt()) {
            return 0;
        }
        return ($object1->getCreatedAt() < $object2->getCreatedAt()) ? 1 : -1;
    }
}
