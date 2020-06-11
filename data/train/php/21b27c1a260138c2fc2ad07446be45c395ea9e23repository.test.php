<?php
/* Repository Test cases generated on: 2011-08-06 19:08:25 : 1312672105*/
App::import('Model', 'Repository');

class RepositoryTestCase extends CakeTestCase {
	var $fixtures = array('app.repository', 'app.user', 'app.repositories_user', 'app.criteria', 'app.document', 'app.tag', 'app.criterias_document', 'app.criterias_user', 'app.expert', 'app.tag');

	function startTest() {
		$this->Repository =& ClassRegistry::init('Repository');
	}

	function endTest() {
		unset($this->Repository);
		ClassRegistry::flush();
	}
	
	function testCreateNewRepository() {
		$data = array(
			'Repository' => array(
				'name' => 'Foo',
				'url' => 'required',
				'description' => 'bar',
				'user_id' => 1,
				'documentpack_size' => 1,
				'challenge_reward' => 1,
			)
		);
		
		$result = $this->Repository->createNewRepository($data);
		$repository = $this->Repository->find('all', array(
			'conditions' => array(
				'Repository.user_id' => 1,
				'Repository.name' => 'Foo',
				'Repository.description' => 'bar',				
				)
			)
		);
		$repo_user = $this->Repository->RepositoriesUser->find('all', array(
			'conditions' => array(
				'user_id' => 1,
				'repository_id' => $repository[0]['Repository']['id']
				),
			'recursive' => -1				
			)		
		);
		
		$this->assertNotNull($result);
		$this->assertTrue(count($repository) == 1);
		$this->assertTrue(count($repo_user) == 1);
	}

}
?>