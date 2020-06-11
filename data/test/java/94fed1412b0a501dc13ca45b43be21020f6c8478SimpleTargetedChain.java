/*     */ package org.apache.axis;
/*     */ 
/*     */ import org.apache.axis.components.logger.LogFactory;
/*     */ import org.apache.axis.handlers.BasicHandler;
/*     */ import org.apache.commons.logging.Log;
/*     */ 
/*     */ public class SimpleTargetedChain extends SimpleChain
/*     */   implements TargetedChain
/*     */ {
/*  32 */   protected static Log log = LogFactory.getLog(SimpleTargetedChain.class.getName());
/*     */   protected Handler requestHandler;
/*     */   protected Handler pivotHandler;
/*     */   protected Handler responseHandler;
/*     */ 
/*     */   public SimpleTargetedChain()
/*     */   {
/*     */   }
/*     */ 
/*     */   public SimpleTargetedChain(Handler handler)
/*     */   {
/*  63 */     this.pivotHandler = handler;
/*  64 */     if (this.pivotHandler != null) {
/*  65 */       addHandler(this.pivotHandler);
/*  66 */       addHandler(new PivotIndicator());
/*     */     }
/*     */   }
/*     */ 
/*     */   public SimpleTargetedChain(Handler reqHandler, Handler pivHandler, Handler respHandler)
/*     */   {
/*  76 */     init(reqHandler, null, pivHandler, null, respHandler);
/*     */   }
/*     */ 
/*     */   protected void init(Handler reqHandler, Handler specialReqHandler, Handler pivHandler, Handler specialRespHandler, Handler respHandler)
/*     */   {
/*  94 */     this.requestHandler = reqHandler;
/*  95 */     if (this.requestHandler != null) {
/*  96 */       addHandler(this.requestHandler);
/*     */     }
/*  98 */     if (specialReqHandler != null) {
/*  99 */       addHandler(specialReqHandler);
/*     */     }
/* 101 */     this.pivotHandler = pivHandler;
/* 102 */     if (this.pivotHandler != null) {
/* 103 */       addHandler(this.pivotHandler);
/* 104 */       addHandler(new PivotIndicator());
/*     */     }
/*     */ 
/* 107 */     if (specialRespHandler != null) {
/* 108 */       addHandler(specialRespHandler);
/*     */     }
/* 110 */     this.responseHandler = respHandler;
/* 111 */     if (this.responseHandler != null)
/* 112 */       addHandler(this.responseHandler); 
/*     */   }
/*     */ 
/*     */   public Handler getRequestHandler() {
/* 115 */     return this.requestHandler;
/*     */   }
/* 117 */   public Handler getPivotHandler() { return this.pivotHandler; } 
/*     */   public Handler getResponseHandler() {
/* 119 */     return this.responseHandler;
/*     */   }
/*     */ 
/*     */   private class PivotIndicator extends BasicHandler
/*     */   {
/*     */     public PivotIndicator()
/*     */     {
/*     */     }
/*     */ 
/*     */     public void invoke(MessageContext msgContext)
/*     */       throws AxisFault
/*     */     {
/*  48 */       msgContext.setPastPivot(true);
/*     */     }
/*     */   }
/*     */ }

/* Location:           E:\Windows\Documents\flashdmp\New folder\ProjectFlashToolV0.01.jar
 * Qualified Name:     org.apache.axis.SimpleTargetedChain
 * JD-Core Version:    0.6.0
 */