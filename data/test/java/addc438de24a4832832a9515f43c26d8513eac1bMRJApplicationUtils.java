/*    */ package com.apple.mrj;
/*    */ 
/*    */ public class MRJApplicationUtils
/*    */ {
/*    */   public static final boolean isMRJToolkitAvailable()
/*    */   {
/* 17 */     return MRJPriv.isMRJToolkitAvailable();
/*    */   }
/*    */ 
/*    */   public static final void registerAboutHandler(MRJAboutHandler paramMRJAboutHandler)
/*    */   {
/* 22 */     MRJPriv.registerAboutHandler(paramMRJAboutHandler);
/*    */   }
/*    */ 
/*    */   public static final void registerOpenApplicationHandler(MRJOpenApplicationHandler paramMRJOpenApplicationHandler)
/*    */   {
/* 27 */     MRJPriv.registerOpenApplicationHandler(paramMRJOpenApplicationHandler);
/*    */   }
/*    */ 
/*    */   public static final void registerOpenDocumentHandler(MRJOpenDocumentHandler paramMRJOpenDocumentHandler)
/*    */   {
/* 32 */     MRJPriv.registerOpenDocumentHandler(paramMRJOpenDocumentHandler);
/*    */   }
/*    */ 
/*    */   public static final void registerPrintDocumentHandler(MRJPrintDocumentHandler paramMRJPrintDocumentHandler)
/*    */   {
/* 37 */     MRJPriv.registerPrintDocumentHandler(paramMRJPrintDocumentHandler);
/*    */   }
/*    */ 
/*    */   public static final void registerQuitHandler(MRJQuitHandler paramMRJQuitHandler)
/*    */   {
/* 42 */     MRJPriv.registerQuitHandler(paramMRJQuitHandler);
/*    */   }
/*    */ 
/*    */   public static final void registerPrefsHandler(MRJPrefsHandler paramMRJPrefsHandler)
/*    */   {
/* 47 */     MRJPriv.registerPrefsHandler(paramMRJPrefsHandler);
/*    */   }
/*    */ }
