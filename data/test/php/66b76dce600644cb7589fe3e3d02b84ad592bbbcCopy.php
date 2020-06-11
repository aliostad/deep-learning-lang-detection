<?php


class Copy extends Eloquent {

	/**
	 * The database table used by the model.
	 *
	 * @var string
	 */
	protected $table = 'copy';

	public $timestamps = false;

	/**
	 * The attributes excluded from the model's JSON form.
	 *
	 * @var array
	 */

	/**
	 * The attributes available for mass assignment
	 *
	 * @var array
	 */
	protected $fillable = array('name', 'content'); 

	public static function named($name)
	{
		return static::where('name', '=', $name)->first();
	}

	public static function block($name, $default = '')
	{
		$copy = static::named($name);
		if( !$copy ) $copy = static::defaultCopy();
		if( $default != '' ) $copy->content = $default;
		if( Auth::check() )
		{
			return "<span class=\"copy\" data-name=\"$name\">$copy->content</span>";
		} else {
			return "<span>$copy->content</span>";
		}
	}

	public static function defaultCopy()
	{
		if( $default = static::named('default-copy') ) 
			return $default;
		else 
			return static::createDefaultCopy();
	}

	public static function createDefaultCopy()
	{
		Eloquent::unguard();
		Copy::create(array(
			'name'      => 'default-copy',
			'content'   => 'This is some default copy'
		));
		return static::named('default-copy');
	}

}
