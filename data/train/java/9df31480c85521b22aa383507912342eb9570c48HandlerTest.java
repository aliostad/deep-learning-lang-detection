package com.dmmikkel.brisk.core.handler;

import org.junit.Assert;
import org.junit.Test;

public class HandlerTest
{
    @Test
    public void testGenerateKey()
            throws Exception
    {
        Handler handler = new HandlerImpl();

        Assert.assertEquals(16, handler.generateKey(16).length());
    }

    @Test(expected = IllegalArgumentException.class)
    public void testGenerateKeyZero()
    {
        Handler handler = new HandlerImpl();

        handler.generateKey(0);
    }

    @Test(expected = IllegalArgumentException.class)
    public void testGenerateKeyNegative()
    {
        Handler handler = new HandlerImpl();

        handler.generateKey(-5);
    }

    @Test(expected = IllegalArgumentException.class)
    public void testGenerateKeyLarge()
    {
        Handler handler = new HandlerImpl();

        handler.generateKey(257);
    }

    @Test
    public void parseUrlParts1()
    {
        Handler handler = new HandlerImpl();
        String[] urlParts = handler.parseUrlParts("/this/is/an/url/");

        Assert.assertEquals("an", urlParts[2]);
    }

    @Test
    public void parseUrlParts2()
    {
        Handler handler = new HandlerImpl();
        String[] urlParts = handler.parseUrlParts("/this/is/an/url/");

        Assert.assertEquals("this", urlParts[0]);
    }

    @Test
    public void parseUrlPartsLength()
    {
        Handler handler = new HandlerImpl();
        String[] urlParts = handler.parseUrlParts("/this/is/an/url/");

        Assert.assertEquals(4, urlParts.length);
    }

    @Test
    public void isValidHostname1()
    {
        Handler handler = new HandlerImpl();

        Assert.assertTrue(handler.isValidHostname("example.com"));
    }

    @Test
    public void isValidHostname2()
    {
        Handler handler = new HandlerImpl();

        Assert.assertTrue(handler.isValidHostname("www.testdomain.no"));
    }

    @Test
    public void isValidHostnamePort()
    {
        Handler handler = new HandlerImpl();

        Assert.assertFalse(handler.isValidHostname("example.com:80"));
    }
}
