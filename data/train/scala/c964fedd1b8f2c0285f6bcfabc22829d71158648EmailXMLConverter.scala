package hr.element.beepo.client
package xml

import email._

import scala.xml.NodeSeq
import hr.element.etb.Pimps._

trait EmailXMLConverter extends XMLConverter { this: Email =>

  private def dump(element: Option[MailElement[_]], label: String) =
    element match {
      case Some(body) =>
        <x>{ body }</x>.copy(label = label)

      case _ =>
        NodeSeq.Empty
    }

  private def dump(addresses: Seq[Address], label: String) =
    if (addresses.nonEmpty) {
      <x>{ addresses.map{ a => <string>{ a }</string> } }</x>.copy(label = label)
    }
    else {
      NodeSeq.Empty
    }

  def toXml =
<EmailSmtpRequest>
  <from>{ from }</from>
  <subject>{ subject } </subject>
  {
    dump(to, "to") ++
    dump(replyTo, "replyTo") ++
    dump(cc, "cc") ++
    dump(bcc, "bcc") ++
    dump(textBody, "textBody") ++
    dump(htmlBody, "htmlBody") ++
    (if (attachments.nonEmpty) {
      <attachments>{ attachments.map{ _.toXml } }</attachments>
    }
    else {
      NodeSeq.Empty
    })
  }
</EmailSmtpRequest>
}
