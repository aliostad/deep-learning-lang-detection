package com.xmlcalabash.model.xml

import com.jafpl.graph.{Graph, Node}
import com.xmlcalabash.config.XMLCalabash
import com.xmlcalabash.exceptions.{ExceptionCode, ModelException}
import com.xmlcalabash.model.util.XProcConstants
import net.sf.saxon.s9api.QName

import scala.collection.mutable.ListBuffer

class Serialization(override val config: XMLCalabash,
                    override val parent: Option[Artifact]) extends Artifact(config, parent) {
  var _port: Option[String] = None
  var _byte_order_mark: Option[Boolean] = None
  var _cdata_section_elements: List[String] = List()
  var _doctype_public: Option[String] = None
  var _doctype_system: Option[String] = None
  var _encoding: Option[String] = None
  var _escape_uri_attributes: Option[Boolean] = None
  var _include_content_type: Option[Boolean] = None
  var _indent: Option[Boolean] = None
  var _media_type: Option[String] = None
  var _method: Option[QName] = None
  var _normalization_form: Option[String] = None
  var _omit_xml_declaration: Option[Boolean] = None
  var _standalone: Option[String] = None
  var _undeclare_prefixes: Option[Boolean] = None
  var _version: Option[String] = None

  override def validate(): Boolean = {
    _port = attributes.get(XProcConstants._port)
    _byte_order_mark = lexicalBoolean(attributes.get(XProcConstants._byte_order_mark))
    _cdata_section_elements = if (attributes.contains(XProcConstants._cdata_section_elements)) {
      attributes(XProcConstants._cdata_section_elements).split("\\s+").toList
    } else {
      List()
    }
    _doctype_public = attributes.get(XProcConstants._doctype_public)
    _doctype_system = attributes.get(XProcConstants._doctype_system)
    _encoding = attributes.get(XProcConstants._encoding)
    _escape_uri_attributes = lexicalBoolean(attributes.get(XProcConstants._escape_uri_attributes))
    _include_content_type = lexicalBoolean(attributes.get(XProcConstants._include_content_type))
    _indent = lexicalBoolean(attributes.get(XProcConstants._indent))
    _media_type = attributes.get(XProcConstants._media_type)
    _method = lexicalQName(attributes.get(XProcConstants._method))
    _normalization_form = attributes.get(XProcConstants._normalization_form)
    _omit_xml_declaration = lexicalBoolean(attributes.get(XProcConstants._omit_xml_declaration))
    _standalone = attributes.get(XProcConstants._standalone)
    _undeclare_prefixes = lexicalBoolean(attributes.get(XProcConstants._undeclare_prefixes))
    _version = attributes.get(XProcConstants._version)

    for (key <- List(XProcConstants._port, XProcConstants._byte_order_mark,
      XProcConstants._cdata_section_elements, XProcConstants._doctype_public,
      XProcConstants._doctype_system, XProcConstants._encoding,
      XProcConstants._escape_uri_attributes, XProcConstants._include_content_type,
      XProcConstants._indent, XProcConstants._media_type, XProcConstants._method,
      XProcConstants._normalization_form, XProcConstants._omit_xml_declaration,
      XProcConstants._standalone, XProcConstants._undeclare_prefixes, XProcConstants._version)) {
      if (attributes.contains(key)) {
        attributes.remove(key)
      }
    }

    if (attributes.nonEmpty) {
      val key = attributes.keySet.head
      throw new ModelException(ExceptionCode.BADATTR, key.toString, location)
    }

    if (_port.isEmpty) {
      throw new ModelException(ExceptionCode.PORTATTRREQ, this.toString, location)
    }

    if (parent.isDefined && !parent.get.outputPorts.contains(_port.get)) {
      throw new ModelException(ExceptionCode.BADSERPORT, _port.get, location)
    }

    if (_standalone.isDefined) {
      if (!List("true", "false", "omit").contains(_standalone.get)) {
        throw new ModelException(ExceptionCode.BADSERSTANDALONE, _standalone.get, location)
      }
      if (children.nonEmpty) {
        throw new ModelException(ExceptionCode.BADCHILD, children.head.toString, location)
      }
    }

    true
  }

  override def asXML: xml.Elem = {
    dumpAttr("cdata-section-elements", if (_cdata_section_elements.nonEmpty) {
      var s = ""
      for (elem <- _cdata_section_elements) {
        if (s != "") {
          s += " "
        }
        s += elem
      }
      Some(s)
    } else {
      None
    })
    dumpAttr("byte-order-mark", _byte_order_mark)
    dumpAttr("doctype-public", _doctype_public)
    dumpAttr("doctype-system", _doctype_system)
    dumpAttr("encoding", _encoding)
    dumpAttr("escape-uri-attributes", _escape_uri_attributes)
    dumpAttr("include-content-type", _include_content_type)
    dumpAttr("indent", _indent)
    dumpAttr("media-type", _media_type)
    dumpAttr("normalization-form", _normalization_form)
    dumpAttr("omit-xml-declaration", _omit_xml_declaration)
    dumpAttr("standalone", _standalone)
    dumpAttr("undeclare-prefixes", _undeclare_prefixes)
    dumpAttr("version", _version)
    dumpAttr("method", _method)
    dumpAttr("port", _port)

    val nodes = ListBuffer.empty[xml.Node]
    if (children.nonEmpty) {
      nodes += xml.Text("\n")
    }
    for (child <- children) {
      nodes += child.asXML
      nodes += xml.Text("\n")
    }
    new xml.Elem("p", "serialization", dump_attr.get, namespaceScope, false, nodes: _*)
  }

  override def makeGraph(graph: Graph, parent: Node) {
    // no direct contribution
  }

  override def makeEdges(graph: Graph, parent: Node) {
    // no direct contribution
  }
}
