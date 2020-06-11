package com.google.inject.internal.asm;

class $Handler
{
  .Label a;
  .Label b;
  .Label c;
  String d;
  int e;
  Handler f;
  
  static Handler a(Handler paramHandler, .Label paramLabel1, .Label paramLabel2)
  {
    if (paramHandler == null) {
      return null;
    }
    paramHandler.f = a(paramHandler.f, paramLabel1, paramLabel2);
    int i = paramHandler.a.c;
    int j = paramHandler.b.c;
    int k = paramLabel1.c;
    int m = paramLabel2 == null ? Integer.MAX_VALUE : paramLabel2.c;
    if ((k < j) && (m > i)) {
      if (k <= i)
      {
        if (m >= j) {
          paramHandler = paramHandler.f;
        } else {
          paramHandler.a = paramLabel2;
        }
      }
      else if (m >= j)
      {
        paramHandler.b = paramLabel1;
      }
      else
      {
        Handler localHandler = new Handler();
        localHandler.a = paramLabel2;
        localHandler.b = paramHandler.b;
        localHandler.c = paramHandler.c;
        localHandler.d = paramHandler.d;
        localHandler.e = paramHandler.e;
        localHandler.f = paramHandler.f;
        paramHandler.b = paramLabel1;
        paramHandler.f = localHandler;
      }
    }
    return paramHandler;
  }
}


/* Location:              D:\Projects\AiCup\CodeRacing\local-runner\local-runner.jar!\com\google\inject\internal\asm\$Handler.class
 * Java compiler version: 2 (46.0)
 * JD-Core Version:       0.7.1
 */