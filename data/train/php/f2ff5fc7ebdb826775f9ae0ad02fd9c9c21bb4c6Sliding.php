<?php

namespace Library\Paginator\Pager\Range;

use Library\Paginator\Pager\Range;

/**
 * \Library\Paginator\Pager\Range\Sliding
 * «Smooth» ranges, e.g.: when on
 *  [1] [2] 3
 *  next range will be:
 *  [3] 4 [5]
 */
class Sliding extends Range
{

    /**
     * {@inheritdoc}
     *
     * @return array
     */
    public function getRange()
    {
        $page = $this->pager->getCurrentPage();
        $pages = $this->pager->getLastPage();

        $chunk = $this->chunkLength;

        if ($chunk > $pages) {
            $chunk = $pages;
        }

        $chunkStart = $page - (floor($chunk / 2));
        $chunkEnd = $page + (ceil($chunk / 2) - 1);

        if ($chunkStart < 1) {
            $adjust = 1 - $chunkStart;
            $chunkStart = 1;
            $chunkEnd = $chunkEnd + $adjust;
        }

        if ($chunkEnd > $pages) {
            $adjust = $chunkEnd - $pages;
            $chunkStart = $chunkStart - $adjust;
            $chunkEnd = $pages;
        }

        return range($chunkStart, $chunkEnd);
    }
}
