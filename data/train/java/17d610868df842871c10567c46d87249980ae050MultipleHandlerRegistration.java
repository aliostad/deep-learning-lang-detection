package es.uned.grc.pfc.meteo.client.view.base;

import java.util.List;

import com.google.gwt.event.shared.HandlerRegistration;


public class MultipleHandlerRegistration implements HandlerRegistration {

   private List <HandlerRegistration> handlerRegistrations = null;
   
   public MultipleHandlerRegistration () {
      
   }
   
   public MultipleHandlerRegistration (List <HandlerRegistration> handlerRegistrations) {
      this.handlerRegistrations = handlerRegistrations;
   }

   @Override
   public void removeHandler () {
      if (handlerRegistrations != null) {
         for (HandlerRegistration handlerRegistration : handlerRegistrations) {
            handlerRegistration.removeHandler ();
         }
      }
   }

   public List <HandlerRegistration> getHandlerRegistrations () {
      return handlerRegistrations;
   }

   public void setHandlerRegistrations (List <HandlerRegistration> handlerRegistrations) {
      this.handlerRegistrations = handlerRegistrations;
   }

}
