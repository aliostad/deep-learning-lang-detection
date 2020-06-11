package eu.sn7.unlocker;

import static org.mockito.Matchers.any;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import eu.sn7.unlocker.process.ProcessFinder;
import eu.sn7.unlocker.process.ProcessKiller;
import eu.sn7.unlocker.util.ListUtil;

@RunWith(MockitoJUnitRunner.class)
public class UnlockProcessTest {
	private static final List<String> PROCESS_IDS = ListUtil.create("1", "2", "3");

	@Mock
	ProcessFinder processFinder;

	@Mock
	ProcessKiller processKiller;

	@Test
	public void testUnlocker() {
		UnlockProcess unlockProcess = new UnlockProcess(processFinder, processKiller);
		when(processFinder.findProcessIds()).thenReturn(PROCESS_IDS);

		unlockProcess.unlock();
		verify(processKiller, times(PROCESS_IDS.size())).killProcess(any(String.class));
	}

}
