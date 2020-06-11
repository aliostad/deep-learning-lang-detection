/**
 * The BSD License
 *
 * Copyright (c) 2010-2012 RIPE NCC
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *   - Redistributions of source code must retain the above copyright notice,
 *     this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright notice,
 *     this list of conditions and the following disclaimer in the documentation
 *     and/or other materials provided with the distribution.
 *   - Neither the name of the RIPE NCC nor the names of its contributors may be
 *     used to endorse or promote products derived from this software without
 *     specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */
package net.ripe.rpki.validator.iana.block

import java.net.URL
import java.text.SimpleDateFormat

import grizzled.slf4j.Logging
import net.ripe.ipresource.IpRange

import scala.concurrent._
import scala.xml.XML

/**
  * Created by fimka on 16/10/16.
  */
class IanaDumpDownloader() extends Logging {

  /**
    * Refreshes the given IanaRisDump. If the source information was not modified or could not be retrieved the input
    * dump is returned.
    */
  def download(dump: IanaAnnouncementSet)(implicit ec: ExecutionContext): Future[IanaAnnouncementSet] = Future {
    try {
      val xmlHandler = makeXmlParser(dump.url, dump)
      blocking {xmlHandler}
    } catch {
      case e: Exception =>
        error("error retrieving IANA entries from " + dump.url, e)
        dump
    }

  }

  protected[block] def makeXmlParser(get: String, dump: IanaAnnouncementSet): IanaAnnouncementSet =
  {

    val ianaRawData = XML.load(new URL(get))
    var ianaRecords = Set[IanaAnnouncement]()
    val dateFormat = new SimpleDateFormat("yyyy-MM")
    (ianaRawData \\"record").foreach{ record =>
      val ip = IpRange.parse((record \\ "prefix").text)
      val designation = (record \\ "designation").text
      val date = dateFormat.parse((record \\ "date").text)
      val status = (record \\ "status").text
      if(status != "ALLOCATED"){
        ianaRecords += new IanaAnnouncement(ip, designation, date, status)
      }

    }
    val a = Seq(ianaRecords)

    dump.copy(entries = ianaRecords.toSeq)
  }

}
