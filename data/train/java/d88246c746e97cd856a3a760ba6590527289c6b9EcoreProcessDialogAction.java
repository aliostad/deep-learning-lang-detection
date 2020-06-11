package org.benhur.process.ecore.ui.action;

import org.benhur.process.ProcessActivator;
import org.benhur.process.eclipse.ui.dialog.impl.GeneratedDateCompositeProcessDialog;
import org.benhur.process.ecore.EcoreProcess;
import org.benhur.process.emf.ui.action.Model2FileProcessDialogAction;

public class EcoreProcessDialogAction extends Model2FileProcessDialogAction<EcoreProcess>
{
  private static EcoreProcess ecore2CodeProcess = new EcoreProcess();
  static
  {
    ecore2CodeProcess.initialize();
  }

  public EcoreProcessDialogAction()
  {
    super(ecore2CodeProcess, new GeneratedDateCompositeProcessDialog(ecore2CodeProcess.getLabel(), ecore2CodeProcess,
        ProcessActivator.getDefault().getPreferences()), ProcessActivator.getDefault().getPreferences());
  }
}
