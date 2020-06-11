<?php

namespace Adriatic\PHPAkademija\Test\DesignPattern\Facade;

use Adriatic\PHPAkademija\DesignPattern\Facade\Amplifier;
use Adriatic\PHPAkademija\DesignPattern\Facade\BluRayPlayer;
use Adriatic\PHPAkademija\DesignPattern\Facade\HomeTheaterFacade;
use Adriatic\PHPAkademija\DesignPattern\Facade\Television;
use PHPUnit\Framework\TestCase;

class FacadeTest extends TestCase
{
    /** @test */
    public function watchMovieEasily()
    {
        $facade = new HomeTheaterFacade(new Television, new BluRayPlayer, new Amplifier);

        ob_start();
        $facade->watchMovie('Dr. Strangelove');
        $facade->endMovie();
        $output = ob_get_contents();
        ob_end_clean();

        $this->assertEquals([
            'Uključen blu ray player',
            'Ubačen film "Dr. Strangelove"',
            'Uključeno pojačalo',
            'Glasnoća postavljena na razinu 15',
            'Uključen TV',
            'Izvor postavljen na "HDMI"',
            'Svjetlina postavljena na razinu 60',
            'Počeo film',
            'Uklonjen film iz blu ray playera',
            'Isključen blu ray player',
            'Isključen TV',
            'Isključeno pojačalo',
            '',
        ], explode('<br />', $output));
    }
}
