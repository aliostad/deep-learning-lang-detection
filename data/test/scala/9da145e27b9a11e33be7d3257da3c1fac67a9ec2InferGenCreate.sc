class InferGenCreate<X> {
   Object instVal;
   InferGenCreate() {
   }

   <T> InferGenCreate(T t) {
      instVal = t;
   }

   Object getInstVal() {
      return instVal;
   }


   @Test
   public void runTest() {
      InferGenCreate<String> myObject = new InferGenCreate<>("str1");
      Object res = myObject.getInstVal();
      assertEquals(res, "str1");
      InferGenCreate<String> myObjectOld = new InferGenCreate<String>("str2");
      Object res2 = myObjectOld.getInstVal();
      assertEquals(res2, "str2");
   }
}
