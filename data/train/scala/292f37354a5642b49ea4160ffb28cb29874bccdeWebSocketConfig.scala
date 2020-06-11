package io.realtimey.config

import org.springframework.context.annotation.Configuration
import org.springframework.messaging.simp.config.MessageBrokerRegistry
import org.springframework.web.socket.config.annotation.{AbstractWebSocketMessageBrokerConfigurer, EnableWebSocketMessageBroker, StompEndpointRegistry}

@Configuration
@EnableWebSocketMessageBroker
class WebSocketConfig extends AbstractWebSocketMessageBrokerConfigurer {
  override def configureMessageBroker(registry: MessageBrokerRegistry): Unit = {
    registry.enableSimpleBroker("/topic")
    registry.setApplicationDestinationPrefixes("/app")
  }

  override def registerStompEndpoints(registry: StompEndpointRegistry): Unit = {
    registry.addEndpoint("/realtimey-io").withSockJS()
  }
}
