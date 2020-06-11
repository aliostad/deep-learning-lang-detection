<?php
use STS\Core;

class CoreTest extends \PHPUnit_Framework_TestCase
{
    /**
     * @test
     */
    public function getValidDefaultInstance()
    {
        $core = Core::getDefaultInstance();
        $this->assertInstanceOf('STS\Core', $core);
    }
    /**
     * @test
     */
    public function getCorrectCoreObjectsForParameters()
    {
        $core = $core = Core::getDefaultInstance();
        $loadableObjects = array(
            'AuthFacade', 'SchoolFacade', 'MemberFacade', 'SurveyFacade', 'PresentationFacade', 'LocationFacade', 'UserFacade'
        );
        foreach ($loadableObjects as $key) {
            $instance = $core->load($key);
            $this->assertInstanceOf('STS\Core\Api\\' . $key, $instance, $key);
        }
    }
}
