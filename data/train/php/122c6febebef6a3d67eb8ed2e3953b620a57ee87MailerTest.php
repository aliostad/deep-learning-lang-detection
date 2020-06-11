<?php

/*
 * This file is part of Laravel Contact.
 *
 * (c) Graham Campbell <graham@alt-three.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace GrahamCampbell\Tests\Contact\Facades;

use GrahamCampbell\Contact\Facades\Mailer as MailerFacade;
use GrahamCampbell\Contact\Mailer;
use GrahamCampbell\TestBenchCore\FacadeTrait;
use GrahamCampbell\Tests\Contact\AbstractTestCase;

/**
 * This is the mailer facade test class.
 *
 * @author Graham Campbell <graham@alt-three.com>
 */
class MailerTest extends AbstractTestCase
{
    use FacadeTrait;

    /**
     * Get the facade accessor.
     *
     * @return string
     */
    protected function getFacadeAccessor()
    {
        return 'contact.mailer';
    }

    /**
     * Get the facade class.
     *
     * @return string
     */
    protected function getFacadeClass()
    {
        return MailerFacade::class;
    }

    /**
     * Get the facade route.
     *
     * @return string
     */
    protected function getFacadeRoot()
    {
        return Mailer::class;
    }
}
