<?php
spl_autoload_register('autoload');

function autoload($class)
{
    require "../../../" . str_replace('\\', '/', $class) . '.php';
}

use StructuralDesignPatterns\Facade\HeadFirst\{
    HomeTheaterFacade,
    Amp,
    CdPlayer,
    DvdPlayer,
    PopcornPopper,
    Projector,
    Screen,
    TheaterLight,
    Tuner
};

$facade = new HomeTheaterFacade(new Amp(),
    new Tuner(),
    new DvdPlayer(),
    new CdPlayer(),
    new Projector(),
    new TheaterLight(),
    new Screen(),
    new PopcornPopper());
$facade->watchMovie("Raiders of the Lost Ark");
$facade->endMovie();

