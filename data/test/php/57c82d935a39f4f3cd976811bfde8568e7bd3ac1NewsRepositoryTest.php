<?php

use Transnatal\Repositories\DBNewsRepository;
use User;

class NewsRepositoryTest extends TestCase {

	public function setUp()
	{
		parent::setUp();
		
	}

	public function test_find()
	{
		$dbNewsRepository = new DBNewsRepository();
		$news = $dbNewsRepository->find(3);
		$this->assertTrue(isset($news));
	}

	public function test_get_first()
	{
		$dbNewsRepository = new DBNewsRepository();
		$news1 = $dbNewsRepository->find(3);
		$this->assertTrue(isset($news1));
		$news2 = $dbNewsRepository->get_first();
		$this->assertTrue(isset($news2));
		$this->assertTrue($news1 == $news2);
	}

	public function test_all()
	{
		$dbNewsRepository = new DBNewsRepository();
		$news = $dbNewsRepository->all();
		$this->assertTrue(count($news) > 0);
	}

	public function test_destroy()
	{
		$dbNewsRepository = new DBNewsRepository();
		$news = $dbNewsRepository->all();
		$last_news = $news[count($news)-1];
		$dbNewsRepository->delete($last_news->id);
		$news2 = $dbNewsRepository->all();
		$this->assertTrue(count($news) - 1 == count($news2));
	}



	public function test_all_avaiable()
	{
		$dbNewsRepository = new DBNewsRepository();
		$news = $dbNewsRepository->allAvaliable();
		$this->assertTrue(count($news) > 0);
	}
}