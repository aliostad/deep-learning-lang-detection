/*
 * Created on Dec 23, 2004
 */
package impl.owls.process;


import org.mindswap.owl.OWLIndividual;
import org.mindswap.owls.process.AtomicProcess;
import org.mindswap.owls.process.CompositeProcess;
import org.mindswap.owls.process.SimpleProcess;
import org.mindswap.owls.vocabulary.OWLS;

/**
 * @author evren
 *
 */
public class SimpleProcessImpl extends ProcessImpl implements SimpleProcess {
    public SimpleProcessImpl(OWLIndividual ind) {
        super(ind);
    }

    /* (non-Javadoc)
     * @see org.mindswap.owls.process.SimpleProcess#getAtomicProcess()
     */
    public AtomicProcess getAtomicProcess() {
        return (AtomicProcess) getPropertyAs(OWLS.Process.realizedBy, AtomicProcess.class);
    }

    /* (non-Javadoc)
     * @see org.mindswap.owls.process.SimpleProcess#getCompositeProcess()
     */
    public CompositeProcess getCompositeProcess() {
        return (CompositeProcess) getPropertyAs(OWLS.Process.expandsTo, CompositeProcess.class);
    }

    /* (non-Javadoc)
     * @see org.mindswap.owls.process.SimpleProcess#setAtomicProcess(org.mindswap.owls.process.AtomicProcess)
     */
    public void setAtomicProcess(AtomicProcess process) {
        setProperty(OWLS.Process.realizedBy, process);
    }

    /* (non-Javadoc)
     * @see org.mindswap.owls.process.SimpleProcess#setCompositeProcess(org.mindswap.owls.process.CompositeProcess)
     */
    public void setCompositeProcess(CompositeProcess process) {
        setProperty(OWLS.Process.expandsTo, process);
    }

}
