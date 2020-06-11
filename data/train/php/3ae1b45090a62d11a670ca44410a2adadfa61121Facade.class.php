<?
/** 	$Id: Facade.class.php 14225 2007-03-15 13:11:47Z andrew $
 *
 *	NAME:
 *
 *		Class:	RM_Tools_Facade
 *		Version:	0.1
 *	  	Patterns:
 *		Interfaces:
 *
 *	SYNOPSIS:
 *
 *
 *
 *	DESCRIPTION:
 *
 *		Facade for different kinds of tools.
 *
 *
 **/
class RM_Tools_Facade
{
	public function __call($name, $args)
	{
		return M('Base')->instance('RM_Tools_'.ucfirst($name), NULL, array('auto_ctor' => 1));
	}
	// BACKWARD compatibility
	function date ()
	{
		return M('Date');
	}
	function image ()
	{
		return M('Image');
	}
}
?>