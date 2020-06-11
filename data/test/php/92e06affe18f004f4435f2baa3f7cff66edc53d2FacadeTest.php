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
		$facade = new Daveawb\Datatables\Facades\Datatable();
		
		$this->assertInstanceOf("Illuminate\Support\Facades\Facade", $facade);
	}
	
	/**
	 * Test that the facade returns the name of the datatables interface
	 */
	public function testFacadeReturnsDatatablesInterface() 
	{
		$method = parent::getMethod("Daveawb\Datatables\Facades\Datatable", "getFacadeAccessor");
		$result = $method->invoke(new Daveawb\Datatables\Facades\Datatable());
		
		$this->assertEquals("Daveawb\Datatables\Datatable", $result);
	}
}
