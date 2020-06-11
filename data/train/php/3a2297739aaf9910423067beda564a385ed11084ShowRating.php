<?php

namespace EtreeDb\Db\Entity\Field\UserShow;
use Zend\Form\Annotation as Form;

trait ShowRating
{
    /**
     * @Form\Type("Zend\Form\Element")
     * @Form\Attributes({"type": "string"})
     * @Form\Attributes({"id": "showRating"})
     * @Form\Options({"label": "Show Rating"})
     */
    protected $showRating;

    public function getShowRating() {
        return $this->showRating;
    }

    public function setShowRating($value) {
        $this->showRating = $value;
        return $this;
    }
}
