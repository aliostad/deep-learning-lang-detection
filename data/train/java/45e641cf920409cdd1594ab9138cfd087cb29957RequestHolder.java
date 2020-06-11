package cn.togeek.netty.handler;

import cn.togeek.netty.handler.TransportService.TimeoutHandler;

public class RequestHolder<Response extends TransportResponse> {
   private final Node node;

   private final TransportResponseHandler<Response> handler;

   private final String action;

   private final TimeoutHandler timeoutHandler;

   RequestHolder(Node node,
                 TransportResponseHandler<Response> handler,
                 String action,
                 TimeoutHandler timeoutHandler)
   {
      this.node = node;
      this.handler = handler;
      this.action = action;
      this.timeoutHandler = timeoutHandler;
   }

   public Node node() {
      return node;
   }

   public TransportResponseHandler<Response> handler() {
      return handler;
   }

   public String action() {
      return action;
   }

   public void cancelTimeout() {
      if(timeoutHandler != null) {
         timeoutHandler.cancel();
      }
   }
}