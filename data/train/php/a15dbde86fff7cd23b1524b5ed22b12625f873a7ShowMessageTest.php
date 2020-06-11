<?php

use FML\ManiaCode\ShowMessage;

class ShowMessageTest extends \PHPUnit_Framework_TestCase
{

    public function testCreate()
    {
        $showMessage = ShowMessage::create("create-message");

        $this->assertTrue($showMessage instanceof ShowMessage);
        $this->assertEquals("create-message", $showMessage->getMessage());
    }

    public function testConstruct()
    {
        $showMessage = new ShowMessage("new-message");

        $this->assertEquals("new-message", $showMessage->getMessage());
    }

    public function testMessage()
    {
        $showMessage = new ShowMessage();

        $this->assertNull($showMessage->getMessage());

        $this->assertSame($showMessage, $showMessage->setMessage("test-message"));

        $this->assertEquals("test-message", $showMessage->getMessage());
    }

    public function testRender()
    {
        $showMessage = new ShowMessage("some-message");

        $domDocument = new \DOMDocument();
        $domElement  = $showMessage->render($domDocument);
        $domDocument->appendChild($domElement);

        $this->assertEquals("<?xml version=\"1.0\"?>
<show_message><message>some-message</message></show_message>
", $domDocument->saveXML());
    }

}
