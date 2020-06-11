package edu.dlsu.mips.util;

import org.junit.Ignore;
import org.junit.Test;

import edu.dlsu.mips.domain.InstructionSet;
import edu.dlsu.mips.domain.PipelineProcess;

public class SystemUtilsTest {

	@Test
	@Ignore
	public void shouldRetrieve() {
		InstructionSet opcode = new InstructionSet();
		PipelineProcess ifProcess = PipelineProcess.newInstance(opcode);
		SystemUtils.addActiveProcess(ifProcess);
		PipelineProcess idProcess = PipelineProcess.newInstance(opcode);
		idProcess.incrementStage();
		SystemUtils.addActiveProcess(idProcess);
		PipelineProcess exeProcess = PipelineProcess.newInstance(opcode);
		exeProcess.incrementStage();
		exeProcess.incrementStage();
		SystemUtils.addActiveProcess(exeProcess);
	}
	


}
