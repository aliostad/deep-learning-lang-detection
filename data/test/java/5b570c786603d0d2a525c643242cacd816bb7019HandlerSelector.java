package ru.spbstu.telematics.lab_4.chat.server;

import java.util.ArrayList;

/**
 * Циклический счетчик для выбора обработчика при
 * новом подключении.
 * @author simonenko
 */
public class HandlerSelector {

   private ArrayList<Handler> handlers;
   private int lastHandlerPosition;
   private int handlersAmount;

   public HandlerSelector(int handlersAmount, Controller controller) {
      this.handlersAmount = handlersAmount;
      handlers = new ArrayList<Handler>(this.handlersAmount);
      for(int i = 0; i < this.handlersAmount; i++) {
         Handler handler = new Handler(i, controller);
         handlers.add(handler);
         handler.start();
      }
      lastHandlerPosition = 0;
   }

   public Handler getHandler() {
      Handler handler = handlers.get(lastHandlerPosition);
      lastHandlerPosition = (lastHandlerPosition < handlersAmount - 1) ? 
            (lastHandlerPosition + 1) : 0;
      return handler;
   }
}
