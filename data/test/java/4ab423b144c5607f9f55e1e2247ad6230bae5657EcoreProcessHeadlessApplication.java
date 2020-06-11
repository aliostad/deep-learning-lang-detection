package org.benhur.process.ecore.application.headless;

import java.util.Collections;

import org.benhur.process.IProcess;
import org.benhur.process.application.headless.ProcessHeadlessApplication;
import org.benhur.process.ecore.EcoreProcess;

public class EcoreProcessHeadlessApplication extends ProcessHeadlessApplication
{
  public EcoreProcessHeadlessApplication()
  {
    super("org.benhur.process.ecore.application.headless.ecore", Collections
        .singletonList((IProcess) new EcoreProcess()));
  }
}
