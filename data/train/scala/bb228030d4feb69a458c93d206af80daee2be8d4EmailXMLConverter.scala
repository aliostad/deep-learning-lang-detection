package com.emajliramokade
package email
package xml

import hr.element.etb.Pimps._
import scala.xml.NodeSeq

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
      addresses.map(a => <x>{ a }</x>.copy(label = label))
    }
    else {
      NodeSeq.Empty
    }

  def toXml =
<Email>
  <from>{ from }</from>
  <subject>{ subject }</subject>
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
</Email>
}
