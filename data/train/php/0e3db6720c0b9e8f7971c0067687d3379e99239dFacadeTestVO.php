<?php
/**
 * PureMVC PHP53n Multicore Unit Tests
 *
 * @author Michel Chouinard <michel.chouinard@gmail.com>
 *
 * Created on Jully 24, 2009
 *
 * @version 1.0
 * @author Michel Chouinard <michel.chouinard@gmail.com>
 * @copyright PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
 * @license http://creativecommons.org/licenses/by/3.0/ Creative Commons Attribution 3.0 Unported License
 */
/**
 *
 */
namespace org\puremvc\php53n\multicore\patterns\facade;

/**
 * A utility class used by FacadeTest.
 *
 * @see org\puremvc\php53n\patterns\facade\FacadeTest FacadeTest
 * @see org\puremvc\php53n\patterns\facade\FacadeTestCommand FacadeTestCommand
 */
class FacadeTestVO
{
    public $input;
    public $result;
    /**
     * Constructor
     *
     * @param input the number to be fed to the FacadeTestCommand
     */
    function __construct( $testValue )
    {
        $this->input = $testValue;
    }
}

?>
