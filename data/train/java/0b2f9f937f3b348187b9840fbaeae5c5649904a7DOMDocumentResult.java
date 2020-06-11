package org.dom4j.io;

import javax.xml.transform.sax.SAXResult;
import org.w3c.dom.Document;
import org.xml.sax.ContentHandler;
import org.xml.sax.ext.LexicalHandler;

public class DOMDocumentResult extends SAXResult {
    private DOMSAXContentHandler contentHandler;

    public DOMDocumentResult() {
        this(new DOMSAXContentHandler());
    }

    public DOMDocumentResult(DOMSAXContentHandler contentHandler) {
        this.contentHandler = contentHandler;
        super.setHandler(this.contentHandler);
        super.setLexicalHandler(this.contentHandler);
    }

    public Document getDocument() {
        return this.contentHandler.getDocument();
    }

    public void setHandler(ContentHandler handler) {
        if (handler instanceof DOMSAXContentHandler) {
            this.contentHandler = (DOMSAXContentHandler) handler;
            super.setHandler(this.contentHandler);
        }
    }

    public void setLexicalHandler(LexicalHandler handler) {
        if (handler instanceof DOMSAXContentHandler) {
            this.contentHandler = (DOMSAXContentHandler) handler;
            super.setLexicalHandler(this.contentHandler);
        }
    }
}