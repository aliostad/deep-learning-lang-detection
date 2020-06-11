<?php
require 'Show.php';
use CablecastPHP\Show;

class ShowTest extends PHPUnit_Framework_TestCase
{

    public function testShowConstructor()
    {
        $show = new Show(100, "Test Title", "Test CG Title", "Test Comments", 300);
        $this->assertEquals($show->getShowID(), 100);
        $this->assertEquals($show->getTitle(), "Test Title");
        $this->assertEquals($show->getCGTitle(), "Test CG Title");
        $this->assertEquals($show->getComments(), "Test Comments");
        $this->assertEquals($show->getLengthInSeconds(), 300);
    }
}
?>