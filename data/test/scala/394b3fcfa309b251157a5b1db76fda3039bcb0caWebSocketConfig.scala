package com.smile.love.websocket

import org.springframework.context.annotation.Configuration
import org.springframework.messaging.simp.config.MessageBrokerRegistry
import org.springframework.web.socket.config.annotation.{AbstractWebSocketMessageBrokerConfigurer, EnableWebSocketMessageBroker, StompEndpointRegistry}
;

@Configuration
@EnableWebSocketMessageBroker
class WebSocketConfig extends AbstractWebSocketMessageBrokerConfigurer{
  override def registerStompEndpoints(stompEndpointRegistry: StompEndpointRegistry): Unit = {
    stompEndpointRegistry.addEndpoint("/wso").withSockJS
  }

  override def configureMessageBroker(registry: MessageBrokerRegistry) = {
    registry.enableSimpleBroker("/wso")
  }
}