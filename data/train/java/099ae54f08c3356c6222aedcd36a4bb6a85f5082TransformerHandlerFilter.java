package be.re.xml.sax;

import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.sax.TransformerHandler;
import org.xml.sax.ContentHandler;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLFilterImpl;

/**
 * Wraps a <code>TransformerHandler</code> in a filter.
 *
 * @author Werner Donn\u00e9
 */
public class TransformerHandlerFilter extends XMLFilterImpl
{
    private final TransformerHandler handler;

    public TransformerHandlerFilter(TransformerHandler handler)
    {
        this.handler = handler;
        super.setContentHandler(handler);
    }

    public TransformerHandlerFilter(TransformerHandler handler, XMLReader parent)
    {
        super(parent);
        this.handler = handler;
        super.setContentHandler(handler);
    }

    @Override
    public void setContentHandler(ContentHandler value)
    {
        handler.setResult(new SAXResult(value));
    }
} // TransformerHandlerFilter
