<?php namespace Bagwaa\FacadeResolver\Commands;

use Illuminate\Console\Command;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;

class FacadeResolverCommand extends Command
{

    protected $name = 'facade:resolve';
    protected $description = 'Resolve a facade quickly to its root class';

    public function fire()
    {
        $this->generateArtisanOutput($this->getFacadeNameFromInput($this->argument('facade')));
    }

    public function generateArtisanOutput($facade)
    {
        if ($this->isFacade($facade)) {
            $rootClass = get_class($facade::getFacadeRoot());
            $this->info("The registered facade '{$facade}' maps to {$rootClass}");
        } else {
            $this->error("Facade not found");
        }
    }

    public function getFacadeNameFromInput($facadeName)
    {
        if ($this->isUppercase($facadeName)) {
            return $facadeName;
        } else {
            return ucfirst(camel_case(strtolower($facadeName)));
        }
    }

    public function getArguments()
    {
        return array(
            array('facade', InputArgument::REQUIRED, 'The name of the registered facade you want to resolve.'),
        );
    }

    public function isFacade($facade)
    {
        if (class_exists($facade)) {
            return array_key_exists('Illuminate\Support\Facades\Facade', class_parents($facade));
        } else {
            return false;
        }
    }

    private function isUppercase($string)
    {
        return (strtoupper($string) == $string);
    }
}
