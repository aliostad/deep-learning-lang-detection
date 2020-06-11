<?php
declare (strict_types = 1);
namespace WebSharks\Core\Test;

use WebSharks\Core\Classes\CoreFacades as c;

require_once dirname(__FILE__, 2).'/includes/local.php';

/* ------------------------------------------------------------------------------------------------------------------ */

$Error = c::error('problem', 'Huge problemo!');
c::dump($Error->slug());
c::dump($Error->message());
c::dump($Error->data());
c::dump($Error->slugs());
c::dump($Error->messages());
c::dump($Error->messages('problem'));
c::dump($Error->message('problem'));
c::dump($Error->remove());
c::dump($Error->messages());
