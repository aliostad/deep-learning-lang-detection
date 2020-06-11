package org.benhur.process.ecore.application.dialog;

import org.benhur.process.ProcessActivator;
import org.benhur.process.application.dialog.ProcessDialogApplication;
import org.benhur.process.ecore2c.Ecore2CProcess;
import org.benhur.process.emf.ui.interaction.impl.EMFDialogInteractor;

public class Ecore2CDialogApplication extends ProcessDialogApplication
{
  public Ecore2CDialogApplication()
  {
    super("Ecore 2 C", new Ecore2CProcess(), new EMFDialogInteractor(), ProcessActivator.getDefault().getPreferences());
  }
}
