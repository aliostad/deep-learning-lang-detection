package net.smartworks.server.engine.process.process.manager;

import net.smartworks.server.engine.process.process.exception.PrcException;
import net.smartworks.server.engine.process.process.model.PrcProcess;
import net.smartworks.server.engine.process.process.model.PrcProcessCond;
import net.smartworks.server.engine.process.process.model.PrcProcessInst;
import net.smartworks.server.engine.process.process.model.PrcProcessInstCond;
import net.smartworks.server.engine.process.process.model.PrcProcessInstExtend;
import net.smartworks.server.engine.process.process.model.PrcProcessInstRel;
import net.smartworks.server.engine.process.process.model.PrcProcessInstRelCond;
import net.smartworks.server.engine.process.process.model.PrcProcessInstVariable;
import net.smartworks.server.engine.process.process.model.PrcProcessInstVariableCond;
import net.smartworks.server.engine.process.process.model.PrcProcessVariable;
import net.smartworks.server.engine.process.process.model.PrcProcessVariableCond;
import net.smartworks.server.engine.process.process.model.PrcSwProcess;
import net.smartworks.server.engine.process.process.model.PrcSwProcessCond;

public interface IPrcManager {
	public PrcProcessInst getProcessInst(String user, String id, String level) throws PrcException;
	public PrcProcessInst getProcessInst(String user, PrcProcessInstCond cond, String level) throws PrcException;
	public void setProcessInst(String user, PrcProcessInst obj, String level) throws PrcException;
	public void removeProcessInst(String user, String id) throws PrcException;
	public long getProcessInstSize(String user, PrcProcessInstCond cond) throws PrcException;
	public PrcProcessInst[] getProcessInsts(String user, PrcProcessInstCond cond, String level) throws PrcException;
	public long getProcessInstExtendsSize(String user, PrcProcessInstCond cond) throws PrcException;
	public PrcProcessInstExtend[] getProcessInstExtends(String user, PrcProcessInstCond cond) throws PrcException;

	public PrcProcess getProcess(String user, String id, String level) throws PrcException;
	public void setProcess(String user, PrcProcess obj, String level) throws PrcException;
	public void removeProcess(String user, String id) throws PrcException;
	public long getProcessSize(String user, PrcProcessCond cond) throws PrcException;
	public PrcProcess[] getProcesses(String user, PrcProcessCond cond, String level) throws PrcException;
	
	public PrcSwProcess[] getSwProcesses(String user, PrcSwProcessCond cond) throws PrcException;
	
	public PrcProcessInstRel getProcessInstRel(String user, String id, String level) throws PrcException;
	public void setProcessInstRel(String user, PrcProcessInstRel obj, String level) throws PrcException;
	public void removeProcessInstRel(String user, String id) throws PrcException;
	public long getProcessInstRelSize(String user, PrcProcessInstRelCond cond) throws PrcException;
	public PrcProcessInstRel[] getProcessInstRels(String user, PrcProcessInstRelCond cond, String level) throws PrcException;

	public PrcProcessInstVariable getProcessInstVariable(String user, String id, String level) throws PrcException;
	public void setProcessInstVariable(String user, PrcProcessInstVariable obj, String level) throws PrcException;
	public void removeProcessInstVariable(String user, String id) throws PrcException;
	public long getProcessInstVariableSize(String user, PrcProcessInstVariableCond cond) throws PrcException;
	public PrcProcessInstVariable[] getProcessInstVariables(String user, PrcProcessInstVariableCond cond, String level) throws PrcException;

	public PrcProcessVariable getProcessVariable(String user, String id, String level) throws PrcException;
	public void setProcessVariable(String user, PrcProcessVariable obj, String level) throws PrcException;
	public void removeProcessVariable(String user, String id) throws PrcException;
	public long getProcessVariableSize(String user, PrcProcessVariableCond cond) throws PrcException;
	public PrcProcessVariable[] getProcessVariables(String user, PrcProcessVariableCond cond, String level) throws PrcException;
}
