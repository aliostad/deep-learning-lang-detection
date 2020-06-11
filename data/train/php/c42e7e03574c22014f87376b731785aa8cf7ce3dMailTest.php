<?php
namespace MOC\PhpUnit\Module;

use MOC\MarkIV\Api;

class MailTest extends \PHPUnit_Framework_TestCase
{

    /** @runTestsInSeparateProcesses */
    public function testMailApi()
    {

        $this->assertInstanceOf( '\MOC\MarkIV\Module\Mail\Smtp\Api', $Api = Api::groupModule()->unitMail()->apiSmtp() );
        $Api->openConnection( 'localhost', 'USER', 'PASS', 25 );
        $Api->apiAddress()->buildFrom( 'ADD@RE.SS' )->setAddress();
        $Api->apiAddress()->buildReply( 'ADD@RE.SS' )->setAddress();
        $Api->apiAddress()->buildTo( 'ADD@RE.SS' )->setAddress();
        $Api->apiAddress()->buildCc( 'ADD@RE.SS' )->setAddress();
        $Api->apiAddress()->buildBcc( 'ADD@RE.SS' )->setAddress();
        $Api->apiContent()->buildSubject( 'Subject' );
        $Api->apiContent()->buildBody( 'Body' );
        $Api->apiContent()->buildAttachment( Api::groupCore()->unitDrive()->apiFile( __FILE__ ) );
        $Api->sendMail();
        $Api->closeConnection();

        $this->assertInstanceOf( '\MOC\MarkIV\Module\Mail\SendMail\Api',
            $Api = Api::groupModule()->unitMail()->apiSendMail() );
        $Api->openConnection( 'localhost', 'USER', 'PASS', 25 );
        $Api->apiAddress()->buildFrom( 'ADD@RE.SS' )->setAddress();
        $Api->apiAddress()->buildReply( 'ADD@RE.SS' )->setAddress();
        $Api->apiAddress()->buildTo( 'ADD@RE.SS' )->setAddress();
        $Api->apiAddress()->buildCc( 'ADD@RE.SS' )->setAddress();
        $Api->apiAddress()->buildBcc( 'ADD@RE.SS' )->setAddress();
        $Api->apiContent()->buildSubject( 'Subject' );
        $Api->apiContent()->buildBody( 'Body' );
        $Api->apiContent()->buildAttachment( Api::groupCore()->unitDrive()->apiFile( __FILE__ ) );
        $Api->sendMail();
        $Api->closeConnection();

        $this->assertInstanceOf( '\MOC\MarkIV\Module\Mail\QMail\Api',
            $Api = Api::groupModule()->unitMail()->apiQMail() );
        $Api->openConnection( 'localhost', 'USER', 'PASS', 25 );
        $Api->apiAddress()->buildFrom( 'ADD@RE.SS' )->setAddress();
        $Api->apiAddress()->buildReply( 'ADD@RE.SS' )->setAddress();
        $Api->apiAddress()->buildTo( 'ADD@RE.SS' )->setAddress();
        $Api->apiAddress()->buildCc( 'ADD@RE.SS' )->setAddress();
        $Api->apiAddress()->buildBcc( 'ADD@RE.SS' )->setAddress();
        $Api->apiContent()->buildSubject( 'Subject' );
        $Api->apiContent()->buildBody( 'Body' );
        $Api->apiContent()->buildAttachment( Api::groupCore()->unitDrive()->apiFile( __FILE__ ) );
        $Api->sendMail();
        $Api->closeConnection();

        $this->assertInstanceOf( '\MOC\MarkIV\Module\Mail\Pop3\Api', $Api = Api::groupModule()->unitMail()->apiPop3() );
        $Api->openConnection( 'localhost', 'USER', 'PASS', 25 );
        $Api->apiAddress()->buildFrom( 'ADD@RE.SS' )->setAddress();
        $Api->apiAddress()->buildReply( 'ADD@RE.SS' )->setAddress();
        $Api->apiAddress()->buildTo( 'ADD@RE.SS' )->setAddress();
        $Api->apiAddress()->buildCc( 'ADD@RE.SS' )->setAddress();
        $Api->apiAddress()->buildBcc( 'ADD@RE.SS' )->setAddress();
        $Api->apiContent()->buildSubject( 'Subject' );
        $Api->apiContent()->buildBody( 'Body' );
        $Api->apiContent()->buildAttachment( Api::groupCore()->unitDrive()->apiFile( __FILE__ ) );
        $Api->sendMail();
        $Api->closeConnection();
    }

    protected function setUp()
    {

        \BufferHandler::obSetUp( __CLASS__ );
    }

    protected function tearDown()
    {

        \BufferHandler::obTearDown();
    }
}
