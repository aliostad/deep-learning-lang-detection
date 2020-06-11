<?php
namespace DbFacade\Tests;
?>


<p class="lead">DbFacade assumes you have got a valid database connection.
Simply pass the connection to <code>DatabaseFacadeAbstract::factory</code>
to get your personal facade concretion.

If you pass something that the factory method can not cope with,
an <code>\InvalidArgumentException</code> will tell you.</p>

<h4>In a nutshell</h4>
<?php
pretty_print('&lt;?php
namespace \MyApp;
use \DbFacade\DatabaseFacadeAbstract;

// $pdo_mysql_conn: Any PDOConnection
$facade = DatabaseFacadeAbstract::factory( $pdo_mysql_conn );
echo get_class( $facade ); // DbFacade\PdoFacade

// $ado_mysql_conn: Any ADOConnection
$facade = DatabaseFacadeAbstract::factory( $ado_mysql_conn );
echo get_class( $facade ); // DbFacade\AdoDbFacade
?&gt;');

