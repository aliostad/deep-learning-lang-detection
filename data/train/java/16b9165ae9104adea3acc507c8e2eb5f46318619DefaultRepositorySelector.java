/*    */ package org.apache.log4j.spi;
/*    */ 
/*    */ public class DefaultRepositorySelector
/*    */   implements RepositorySelector
/*    */ {
/*    */   final LoggerRepository repository;
/*    */ 
/*    */   public DefaultRepositorySelector(LoggerRepository repository)
/*    */   {
/* 28 */     this.repository = repository;
/*    */   }
/*    */ 
/*    */   public LoggerRepository getLoggerRepository()
/*    */   {
/* 33 */     return this.repository;
/*    */   }
/*    */ }

/* Location:           D:\test\Fusion Installer.jar
 * Qualified Name:     org.apache.log4j.spi.DefaultRepositorySelector
 * JD-Core Version:    0.6.0
 */