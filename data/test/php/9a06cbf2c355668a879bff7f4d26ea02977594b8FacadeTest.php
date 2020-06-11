<?php
/**
 * Facade Test
 *
 * @package Daveawb/Datatables
 * @author  David Barker
 * @license MIT
 */
class FacadeTest extends DatatablesTestCase {
	
	/**
	 * Test that the facade extends Laravels facade implementation
	 */
	public function testFacadeExtendsFacade() 
	{
		$facade = new Genius\Datatables\Facades\Datatable();
		
		$this->assertInstanceOf("Illuminate\Support\Facades\Facade", $facade);
	}
	
	/**
	 * Test that the facade returns the name of the datatables interface
	 */
	public function testFacadeReturnsDatatablesInterface() 
	{
		$method = parent::getMethod("Genius\Datatables\Facades\Datatable", "getFacadeAccessor");
		$result = $method->invoke(new Genius\Datatables\Facades\Datatable());
		
		$this->assertEquals("Genius\Datatables\Datatable", $result);
	}
}
