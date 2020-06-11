<?php namespace TestSuite;

use Bagwaa\FacadeResolver\Commands\FacadeResolverCommand;
use Symfony\Component\Console\Tester\CommandTester;
use Orchestra\Testbench\TestCase as TestCase;

class FacadeResolverCommandTest extends TestCase
{
    private $command;
    private $tester;

    public function __construct()
    {
        $this->command = new FacadeResolverCommand();
        $this->tester = new CommandTester($this->command);
    }

    public function testGenerateArtisanOutput()
    {
        $expected = "The registered facade 'App' maps to Illuminate\Foundation\Application\n";
        $this->tester->execute(array('facade' => 'App'));
        $this->assertSame($expected, $this->tester->getDisplay());

        $expected = "The registered facade 'Paginator' maps to Illuminate\Pagination\Environment\n";
        $this->tester->execute(array('facade' => 'Paginator'));
        $this->assertSame($expected, $this->tester->getDisplay());
    }

    public function testGenerateArtisanOutputWithNonFacade()
    {
        $expected = "Facade not found\n";
        $this->tester->execute(array('facade' => 'WonkeyDonkey'));
        $this->assertSame($expected, $this->tester->getDisplay());
    }

    public function testGetFacadeNameFromInputReturnsCorrectFacadeNameWithValidFacadeArgument()
    {
        $this->assertSame('App', $this->command->getFacadeNameFromInput('APp'));
        $this->assertSame('Form', $this->command->getFacadeNameFromInput('FoRM'));
        $this->assertSame('Form', $this->command->getFacadeNameFromInput('form'));
        $this->assertSame('Form', $this->command->getFacadeNameFromInput('Form'));
        $this->assertSame('Paginator', $this->command->getFacadeNameFromInput('PagiNAtor'));
    }

    public function testGetFacadeNameFromInputReturnsCorrectFacadeWithAllCapitalFacadeArgument()
    {
        $this->assertSame('URL', $this->command->getFacadeNameFromInput('URL'));
        $this->assertSame('DB', $this->command->getFacadeNameFromInput('DB'));
        $this->assertSame('HTML', $this->command->getFacadeNameFromInput('HTML'));
    }

    public function testGetArgumentsIsReturningAnArray()
    {
        $actual = $this->command->getArguments();
        $this->assertTrue(is_array($actual));
    }

    public function testGetArgumentsReturnsFacadeRequired()
    {
        $actual = $this->command->getArguments();
        $this->assertContains('facade', $actual[0]);
    }

    public function testIsFacade()
    {
        $this->assertTrue($this->command->isFacade('App'));
        $this->assertTrue($this->command->isFacade('Form'));
        $this->assertTrue($this->command->isFacade('Event'));
        $this->assertTrue($this->command->isFacade('HTML'));
        $this->assertTrue($this->command->isFacade('DB'));
    }

    public function testIsNotFacade()
    {
        $this->assertFalse($this->command->isFacade('AppleChairFlewChickenRaw'));
        $this->assertFalse($this->command->isFacade('CowHoopHelicopterDogRunning'));
        $this->assertFalse($this->command->isFacade('DonkeySofaCarpetMarketFood'));
    }

    public function testIsClassButNotFacade()
    {
        $this->assertFalse($this->command->isFacade('Str'));
        $this->assertFalse($this->command->isFacade('Seeder'));
    }

}

