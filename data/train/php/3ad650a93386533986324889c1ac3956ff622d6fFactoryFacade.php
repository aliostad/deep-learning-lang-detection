<?php

/**
 * Implementation of the Factory design pattern, using a very simple approach. Creates a new Facade instance based on constants passed to createInstance.
 * 
 * TODO Refactor to use namespaces when ZF2 is released
 * 
 * @author fernando
 */
class FernandoMantoan_DesignPatterns_Factory_FactoryFacade
{
	const FACADE_PUBLISHER = 1;
	const FACADE_AUTHOR = 2;
	const FACADE_BOOK = 3;
	const FACADE_LOAN = 4;
	const FACADE_USER = 5;
	const FACADE_MEMBER = 6;
	const FACADE_AUTH = 7;

	public static function createInstance($facade)
	{
		switch ($facade) {
			case self::FACADE_PUBLISHER:
				return new Library_Business_Facade_Publisher();
			break;
			case self::FACADE_AUTHOR:
				return new Library_Business_Facade_Author();
			break;
			case self::FACADE_BOOK:
				return new Library_Business_Facade_Book();
			break;
			case self::FACADE_LOAN:
				return new Library_Business_Facade_Loan();
			break;
			case self::FACADE_USER:
				return new Library_Business_Facade_User();
			break;
			case self::FACADE_MEMBER:
				return new Library_Business_Facade_Member();
			break;
			case self::FACADE_AUTH:
				return new Library_Business_Facade_Auth();
			break;
			default:
				throw new Exception('The facade specified is invalid.');
			break;
		}
	}
}