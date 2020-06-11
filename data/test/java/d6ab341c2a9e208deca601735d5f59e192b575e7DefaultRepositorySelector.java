/*  1:   */ package org.apache.log4j.spi;
/*  2:   */ 
/*  3:   */ public class DefaultRepositorySelector
/*  4:   */   implements RepositorySelector
/*  5:   */ {
/*  6:   */   final LoggerRepository repository;
/*  7:   */   
/*  8:   */   public DefaultRepositorySelector(LoggerRepository repository)
/*  9:   */   {
/* 10:29 */     this.repository = repository;
/* 11:   */   }
/* 12:   */   
/* 13:   */   public LoggerRepository getLoggerRepository()
/* 14:   */   {
/* 15:34 */     return this.repository;
/* 16:   */   }
/* 17:   */ }


/* Location:           G:\ParasiteTrade\Parasite_20150226.jar
 * Qualified Name:     org.apache.log4j.spi.DefaultRepositorySelector
 * JD-Core Version:    0.7.0.1
 */