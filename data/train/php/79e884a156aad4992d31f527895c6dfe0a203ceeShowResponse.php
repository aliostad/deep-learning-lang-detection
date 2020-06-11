<?php

namespace Adrenth\Tvrage\Response;

use Adrenth\Tvrage\Show;

/**
 * Class ShowResponse
 *
 * @category Tvrage
 * @package  Adrenth\Tvrage\Response
 * @author   Alwin Drenth <adrenth@gmail.com>
 * @license  http://opensource.org/licenses/MIT The MIT License (MIT)
 * @link     https://github.com/adrenth/tvrage
 */
class ShowResponse implements ResponseInterface
{
    /**
     * Show
     *
     * @type Show
     */
    private $show;

    /**
     * Construct
     *
     * @param Show|null $show
     */
    public function __construct(Show $show = null)
    {
        $this->show = $show;
    }

    /**
     * Get show
     *
     * @return Show
     */
    public function getShow()
    {
        return $this->show;
    }

    /**
     * Has show
     *
     * @return bool
     */
    public function hasShow()
    {
        return $this->show !== null;
    }
}
