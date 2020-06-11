<?php
namespace Squid\MySql\Impl\Connectors\Object\Primary;


use PHPUnit\Framework\TestCase;


class TIdSaveTest extends TestCase
{
	public function test_save_SingleNewObject_ReturnCountFromInsert()
	{
		$subject = new TIdSaveTestHelper();
		$subject->insertRes = 2;
		$subject->updateRes = 1;
		
		self::assertEquals(2, $subject->save(TIdSaveTestObject::a()));
	}
	
	public function test_save_SingleNewObject_ReturnCountFromUpdate()
	{
		$subject = new TIdSaveTestHelper();
		$subject->insertRes = 2;
		$subject->updateRes = 1;
		
		self::assertEquals(1, $subject->save(TIdSaveTestObject::a(1)));
	}
	
	public function test_save_SingleObjectErrorForInsert_ReturnFalse()
	{
		$subject = new TIdSaveTestHelper();
		$subject->insertRes = false;
		$subject->updateRes = 1;
		
		self::assertFalse($subject->save(TIdSaveTestObject::a()));
	}
	
	public function test_save_SingleObjectErrorForUpdate_ReturnFalse()
	{
		$subject = new TIdSaveTestHelper();
		$subject->insertRes = 1;
		$subject->updateRes = false;
		
		self::assertFalse($subject->save(TIdSaveTestObject::a(1)));
	}
	
	
	public function test_save_ArrayOfInsertedObjects_ReturnCount()
	{
		$subject = new TIdSaveTestHelper();
		$subject->insertRes = 2;
		$subject->updateRes = 1;
		
		self::assertEquals(2, $subject->save([TIdSaveTestObject::a(), TIdSaveTestObject::a()]));
	}
	
	public function test_save_ArrayOfUpdatedObjects_ReturnCount()
	{
		$subject = new TIdSaveTestHelper();
		$subject->insertRes = 2;
		$subject->updateRes = 1;
		
		self::assertEquals(1, $subject->save([TIdSaveTestObject::a(1), TIdSaveTestObject::a(2)]));
	}
	
	public function test_save_MixedArray_ReturnSum()
	{
		$subject = new TIdSaveTestHelper();
		$subject->insertRes = 2;
		$subject->updateRes = 1;
		
		self::assertEquals(3, $subject->save([TIdSaveTestObject::a(), TIdSaveTestObject::a(2)]));
	}
	
	
	public function test_save_SingleNewObject_ObjectPassedToInsert()
	{
		$subject = new TIdSaveTestHelper();
		$obj = TIdSaveTestObject::a();
		
		$subject->save($obj);
		
		self::assertSame([$obj], $subject->inserted);
	}
	
	public function test_save_SingleUpdatedObject_ObjectPassedToUpdate()
	{
		$subject = new TIdSaveTestHelper();
		$obj = TIdSaveTestObject::a(1);
		
		$subject->save($obj);
		
		self::assertSame([$obj], $subject->updated);
	}
	
	
	public function test_save_ArrayOfNewObjects_ObjectsPassedToInsert()
	{
		$subject = new TIdSaveTestHelper();
		$obj1 = TIdSaveTestObject::a();
		$obj2 = TIdSaveTestObject::a();
		
		$subject->save([$obj1, $obj2]);
		
		self::assertSame([$obj1, $obj2], $subject->inserted[0]);
	}
	
	public function test_save_ArrayOfUpdatedObject_ObjectPassedToUpdate()
	{
		$subject = new TIdSaveTestHelper();
		$obj1 = TIdSaveTestObject::a(1);
		$obj2 = TIdSaveTestObject::a(2);
		
		$subject->save([$obj1, $obj2]);
		
		self::assertSame([$obj1, $obj2], $subject->updated[0]);
	}
	
	public function test_save_MixedObjectsPassed()
	{
		$subject = new TIdSaveTestHelper();
		$obj1 = TIdSaveTestObject::a(1);
		$obj2 = TIdSaveTestObject::a();
		$obj3 = TIdSaveTestObject::a(2);
		$obj4 = TIdSaveTestObject::a();
		
		$subject->save([$obj1, $obj2, $obj3, $obj4]);
		
		self::assertSame([$obj1, $obj3], $subject->updated[0]);
		self::assertSame([$obj2, $obj4], $subject->inserted[0]);
	}
}


class TIdSaveTestObject
{
	public $a = null;
	
	public function __construct($a = null)
	{
		$this->a = $a;
	}
	
	public static function a($a = null)
	{
		return new self($a);
	}
}


class TIdSaveTestHelper
{
	use TIdSave;

	
	public $id = 'a';
	public $inserted = [];
	public $updated = [];
	
	public $insertRes = 1;
	public $updateRes = 1;
	
	
	protected function getIdProperty(): string
	{
		return $this->id;
	}

	public function insert($object)
	{
		$this->inserted[] = $object;
		return $this->insertRes;
	}

	public function upsert($object)
	{
		$this->updated[] = $object;
		return $this->updateRes;
	}
}