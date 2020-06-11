<?php
//////////////////////////////////////////////////////////////////////
// Created by armand
// Date: 4/10/14
// Time: 9:02 PM
// For: CookieSync


namespace CookieSync\Stat;


use Game;
use Illuminate\Support\Facades\Log;
use Save;

class GlobalCookieCounter {


    /**
     * @var \Game
     */
    private $game;
    /**
     * @var \Save
     */
    private $save;

    function __construct(Game $game, Save $save)
    {
        $this->game = $game;
        $this->save = $save;
    }

    public function calculateGameCookies()
    {
        $total = '1';
        foreach ($this->gameBatch() as $game) {
            $total = bcadd($total, $game->latestSave()->noCache()->cookies());
        }

        return $total;

    }

    public function calculateEverySave()
    {
        $total = '1';
        foreach ($this->saveBatch() as $save) {
            $total = bcadd($total, $save->noCache()->cookies());
        }

        return $total;
    }

    private function gameBatch($batchSize = 10)
    {
        $globalGameCount = $this->game->count();

        for ($i = 0; $i < $globalGameCount; $i += $batchSize)
        {
            foreach($this->game->skip($i)->take(10)->get() as $game)
            {
                yield $game;
            }
        }
    }

    private function saveBatch($batchSize = 10)
    {
        $globalSaveCount = $this->save->count();

        for ($i = 0; $i < $globalSaveCount; $i += $batchSize)
        {
            foreach($this->save->skip($i)->take(10)->get() as $save)
            {
                yield $save;
            }
        }
    }

} 
