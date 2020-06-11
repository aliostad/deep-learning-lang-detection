package org.benhur.process.ecore;

import org.benhur.process.IProcess;
import org.benhur.process.ecore2c.Ecore2CProcess;
import org.benhur.process.ecore2java.Ecore2JavaProcess;
import org.benhur.process.emf.impl.AModel2FileCompositeProcess;

public class EcoreProcess extends AModel2FileCompositeProcess
{
  public EcoreProcess()
  {
    super("ecore", "Ecore", "Ecore", "ecore", null);
  }

  @Override
  protected void declareSubProcesses()
  {
    addSubProcess((IProcess) new Ecore2CProcess(), false);
    addSubProcess((IProcess) new Ecore2JavaProcess(), false);
  }
}
