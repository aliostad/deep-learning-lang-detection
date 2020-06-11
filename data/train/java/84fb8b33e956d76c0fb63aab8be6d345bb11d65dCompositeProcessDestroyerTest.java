package uk.co.datumedge.redislauncher;

import static org.hamcrest.Matchers.is;
import static org.junit.Assert.assertThat;

import java.io.IOException;

import org.apache.commons.exec.ProcessDestroyer;
import org.jmock.Expectations;
import org.jmock.Mockery;
import org.jmock.integration.junit4.JMock;
import org.jmock.integration.junit4.JUnit4Mockery;
import org.junit.Test;
import org.junit.runner.RunWith;

@RunWith(JMock.class)
public final class CompositeProcessDestroyerTest {
	private static final ProcessDestroyer IGNORED_PROCESS_DESTROYER = null;
	private final Mockery context = new JUnit4Mockery();
	private final ProcessDestroyer delegateProcessDestroyer1 = context.mock(ProcessDestroyer.class, "delegateProcessDestroyer1");
	private final ProcessDestroyer delegateProcessDestroyer2 = context.mock(ProcessDestroyer.class, "delegateProcessDestroyer2");
	private final Process process;

	public CompositeProcessDestroyerTest() throws IOException {
		 process = new ProcessBuilder("java").start();
	}

	@Test
	public void addsProcessToDelegateProcessDestroyer() {
		context.checking(new Expectations() {{
			oneOf(delegateProcessDestroyer1).add(process);
			oneOf(delegateProcessDestroyer2).add(process);
		}});

		new CompositeProcessDestroyer(delegateProcessDestroyer1, delegateProcessDestroyer2).add(process);
	}

	@Test
	public void removesProcessToDelegateProcessDestroyer() {
		context.checking(new Expectations() {{
			oneOf(delegateProcessDestroyer1).remove(process);
			oneOf(delegateProcessDestroyer2).remove(process);
		}});

		new CompositeProcessDestroyer(delegateProcessDestroyer1, delegateProcessDestroyer2).remove(process);
	}

	@Test
	public void addingProcessReturnsTrue() {
		context.checking(new Expectations() {{
			ignoring(delegateProcessDestroyer1);
		}});

		assertThat(new CompositeProcessDestroyer(delegateProcessDestroyer1).add(process), is(true));
	}

	@Test
	public void removingProcessReturnsTrue() {
		context.checking(new Expectations() {{
			ignoring(delegateProcessDestroyer1);
		}});

		assertThat(new CompositeProcessDestroyer(delegateProcessDestroyer1).remove(process), is(true));
	}
	
	@Test
	public void returnsSizeOfNegativeOne() {
		assertThat(new CompositeProcessDestroyer(IGNORED_PROCESS_DESTROYER).size(), is(-1));
	}
}
