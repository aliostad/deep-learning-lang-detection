package com.secretapp.backend

import akka.actor.ActorSystem
import com.secretapp.backend.api.counters._
import com.secretapp.backend.api.DialogManager
import com.secretapp.backend.services.rpc.presence.{ GroupPresenceBroker, PresenceBroker }
import com.secretapp.backend.services.rpc.typing.TypingBroker
import com.secretapp.backend.sms.{ SmsEnginesActor, TwilioSmsEngine }
import com.notnoop.apns.APNS
import com.typesafe.config.ConfigFactory

package object api {
  final class Singletons(implicit val system: ActorSystem) {
    val dialogManagerRegion = DialogManager.startRegion()
    val typingBrokerRegion = TypingBroker.startRegion()
    val presenceBrokerRegion = PresenceBroker.startRegion()
    val groupPresenceBrokerRegion = GroupPresenceBroker.startRegion()
    val apnsService = APNS.newService.withCert(
      system.settings.config.getString("apns.cert.path"),
      system.settings.config.getString("apns.cert.password")
    ).withProductionDestination.build

    val smsEngines = SmsEnginesActor()
  }
}
