package io.octopus.config

import org.springframework.context.annotation.Configuration
import org.springframework.messaging.simp.config.MessageBrokerRegistry
import org.springframework.web.socket.config.annotation._

@Configuration
@EnableWebSocketMessageBroker
class WebSocketConfig extends AbstractWebSocketMessageBrokerConfigurer {

  
  override def configureMessageBroker(config: MessageBrokerRegistry)= {
    config.enableSimpleBroker("/topic")
    config.setApplicationDestinationPrefixes("/application")
  }

  override def registerStompEndpoints(registry: StompEndpointRegistry) = {
    registry.addEndpoint("/socket").withSockJS
  }

}
