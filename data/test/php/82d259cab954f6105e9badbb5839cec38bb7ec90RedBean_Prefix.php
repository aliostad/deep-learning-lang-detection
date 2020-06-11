<?php

class RedBean_Prefix
{
	/**
	 * Mapping RedBean Writer classes to their prefixing counterparts
	 *
	 * @var array
	 */
	private static $alias = array(
		'RedBean_QueryWriter_CUBRID'     => 'PrefixedCubridQueryWriter',
		'RedBean_QueryWriter_MySQL'      => 'PrefixedMysqlQueryWriter',
		'RedBean_QueryWriter_PostgreSQL' => 'PrefixedPostgreSqlQueryWriter',
		'RedBean_QueryWriter_SQLiteT'    => 'PrefixedSQLiteTQueryWriter'
	);

	/**
	 * Modify RedBean to use a prefixing query writer
	 *
	 * @param string $prefix
	 * @param mixed  $facade null|RedBean_Facade
	 */
	public static function prefix( $prefix, $facade=null )
	{
		if ( is_null($facade) ) {
			$class = get_class(R::$writer);
		} else {
			$class = get_class($facade::$writer);
		}

		// For switching instead of creating prefixes
		if ( array_search($class, self::$alias) !== false ) {
			if ( is_null($facade) ) {
				R::$writer->setPrefix($prefix);
			} else {
				$writer = new $class($facade::$adapter, $prefix);

				$facade::$writer->setPrefix($prefix);
			}

			return;
		}

		$class = self::$alias[$class];

		if ( is_null($facade) ) {
			$writer = new $class(R::$adapter, $prefix);

			R::setWriter($writer);
		} else {
			$writer = new $class($facade::$adapter, $prefix);

			$facade::setWriter($writer);
		}
	}
}
