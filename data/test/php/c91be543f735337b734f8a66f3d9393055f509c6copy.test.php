<?php 
/* SVN FILE: $Id$ */
/* Copy Test cases generated on: 2009-07-13 14:07:09 : 1247487789*/
App::import('Model', 'Copy');

class CopyTestCase extends CakeTestCase {
	var $Copy = null;
	var $fixtures = array('app.copy', 'app.original', 'app.user');

	function startTest() {
		$this->Copy =& ClassRegistry::init('Copy');
	}

	function testCopyInstance() {
		$this->assertTrue(is_a($this->Copy, 'Copy'));
	}

	function testCopyFind() {
		$this->Copy->recursive = -1;
		$results = $this->Copy->find('first');
		$this->assertTrue(!empty($results));

		$expected = array('Copy' => array(
			'id'  => 1,
			'original_id'  => 1,
			'user_id'  => 1,
			'description'  => 'Lorem ipsum dolor sit amet',
			'created'  => '2009-07-13 14:23:09'
		));
		$this->assertEqual($results, $expected);
	}
}
?>