<?php
namespace AppBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * Class ScheduledShow
 * @package AppBundle\Entity
 * @ORM\Entity
 * @ORM\Table
 */
class ScheduledShow extends ScheduledItem
{

    /**
     * @var Show
     * @ORM\OneToOne(targetEntity="Show", inversedBy="scheduledItem")
     */
    protected $show;

    /**
     * @return Show
     */
    public function getShow()
    {
        return $this->show;
    }

    /**
     * @param Show $show
     * @return ScheduledShow
     */
    public function setShow($show)
    {
        $this->show = $show;
        return $this;
    }


    public function __toString()
    {
        return $this->show->__toString();
    }
}