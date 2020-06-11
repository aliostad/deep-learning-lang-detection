package net.rambaldi.process;

import net.rambaldi.process.ProcessCreationException;
import net.rambaldi.process.SimpleProcessFactory;
import org.junit.Test;

import static org.junit.Assert.*;

public class SimpleProcessFactoryTest {

    @Test(expected = NullPointerException.class)
    public void constructor_requires_ProcessBuilder() throws Exception {
        new SimpleProcessFactory(null);
    }

    @Test(expected = ProcessCreationException.class)
    public void newInstance_throws_ProcessCreationException_on_failure() throws Exception {
        ProcessBuilder builder = new ProcessBuilder();
        SimpleProcessFactory factory = new SimpleProcessFactory(builder);
        factory.newInstance();
    }

    @Test
    public void newInstance_creates_process() throws Exception {
        ProcessBuilder builder = new ProcessBuilder();
        builder.command("java");
        SimpleProcessFactory factory = new SimpleProcessFactory(builder);
        Process process = factory.newInstance();
        assertNotNull(process);
        process.destroy();
    }
}
