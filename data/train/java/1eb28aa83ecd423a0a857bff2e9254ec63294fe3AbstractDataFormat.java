package es.uji.apps.lod.data.format;

import org.openrdf.repository.Repository;
import org.openrdf.repository.RepositoryConnection;
import org.openrdf.repository.RepositoryException;
import org.openrdf.repository.sail.SailRepository;
import org.openrdf.rio.RDFFormat;
import org.openrdf.rio.RDFHandlerException;
import org.openrdf.rio.RDFWriter;
import org.openrdf.rio.Rio;
import org.openrdf.sail.Sail;

import java.io.OutputStream;

public abstract class AbstractDataFormat
{
    protected void export(Sail sail, RDFFormat format, OutputStream output) throws RepositoryException, RDFHandlerException
    {
        Repository repository = new SailRepository(sail);
        RepositoryConnection repositoryConnection = repository.getConnection();

        try
        {
            RDFWriter w = Rio.createWriter(format, output);
            repositoryConnection.export(w);
        }
        finally
        {
            repositoryConnection.close();
        }
    }
}
