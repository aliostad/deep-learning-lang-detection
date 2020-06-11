// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) fieldsfirst noctor space 

package org.apache.log4j.spi;


// Referenced classes of package org.apache.log4j.spi:
//            RepositorySelector, LoggerRepository

public class DefaultRepositorySelector
    implements RepositorySelector
{

    final LoggerRepository repository;

    public DefaultRepositorySelector(LoggerRepository loggerrepository)
    {
        repository = loggerrepository;
    }

    public LoggerRepository getLoggerRepository()
    {
        return repository;
    }
}
