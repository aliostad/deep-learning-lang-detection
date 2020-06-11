package com.cloudwick.capstone.dashboard

import org.springframework.context.annotation.Configuration
import org.springframework.messaging.simp.config.MessageBrokerRegistry
import org.springframework.web.socket.config.annotation.{AbstractWebSocketMessageBrokerConfigurer, EnableWebSocketMessageBroker, StompEndpointRegistry}


/**
  * Created by VenkataRamesh on 5/21/2017.
  */

/**
  * Web-Socket message broker configuration class to send data using SockJS
  * to dashboard html page.
  **/

@Configuration
@EnableWebSocketMessageBroker
class WebSocketConfig extends AbstractWebSocketMessageBrokerConfigurer {
  //sockJS can get message using this endpoint
  override def registerStompEndpoints(registry: StompEndpointRegistry): Unit = {
    registry.addEndpoint("/stomp").withSockJS
  }

  //configure message broker
  override def configureMessageBroker(config: MessageBrokerRegistry): Unit = {
    config.enableSimpleBroker("/topic")
  }

}
