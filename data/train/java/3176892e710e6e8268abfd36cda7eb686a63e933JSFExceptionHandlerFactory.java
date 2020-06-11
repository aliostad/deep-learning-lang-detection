package exceptions;
import javax.faces.context.ExceptionHandler;
import javax.faces.context.ExceptionHandlerFactory;


public class JSFExceptionHandlerFactory extends ExceptionHandlerFactory {

   private ExceptionHandlerFactory parent;

   public JSFExceptionHandlerFactory(ExceptionHandlerFactory parent ) {
      this.parent = parent;
   }

   @Override
   public ExceptionHandler getExceptionHandler() {
	   ExceptionHandler result = parent.getExceptionHandler();
      result = new JSFExceptionHandler(result);
      return result;
   }

}