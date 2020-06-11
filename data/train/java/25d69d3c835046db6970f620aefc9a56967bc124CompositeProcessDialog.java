package org.benhur.process.eclipse.ui.dialog.impl;

import org.benhur.process.ICompositeProcess;
import org.benhur.process.IProcess;
import org.benhur.process.eclipse.ui.parameter.description.visitor.impl.CreateCompositeParameterDescriptionVisitor;
import org.benhur.process.impl.CompositeProcessConstants;
import org.benhur.process.impl.ProcessConstants;
import org.benhur.process.parameter.description.IParameterDescription;
import org.benhur.utility.ui.composite.CompositeUtility;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Composite;
import org.osgi.service.prefs.Preferences;

public class CompositeProcessDialog extends ProcessDialog<ICompositeProcess>
{
  public CompositeProcessDialog(String name, ICompositeProcess compositeProcess, Preferences preferences)
  {
    super(name, compositeProcess, preferences);
  }

  @Override
  protected void createProcessContent(ICompositeProcess compositeProcess, Composite container)
  {
    for (IParameterDescription<?> parameterDescription : compositeProcess.getParameterDescriptionsForProcess())
    {
      boolean displayParameter = isProcessParameterDisplayed(compositeProcess, parameterDescription);
      if (displayParameter)
      {
        CreateCompositeParameterDescriptionVisitor visitor = new CreateCompositeParameterDescriptionVisitor();
        visitor.init(container, nbColumns, preferences);
        parameterDescription.accept(visitor);
      }
    }
    createSubProcessesContent(compositeProcess, container);
  }

  protected void createSubProcessesContent(ICompositeProcess compositeProcess, Composite container)
  {
    for (IProcess subProcess : compositeProcess.getSubProcesses())
    {
      Composite subProcessContainer = createSubProcessContainer(compositeProcess, subProcess, container);

      createSubProcessContent(compositeProcess, subProcess, subProcessContainer);
    }
  }

  protected Composite createSubProcessContainer(ICompositeProcess compositeProcess, IProcess subProcess,
      Composite container)
  {
    Composite group = null;
    if (compositeProcess.isSubProcessMandatory(subProcess))
    {
      group = CompositeUtility.createGroupBlock(container, nbColumns, subProcess.getLabel(), null);
    }
    else
    {
      group = CompositeUtility.createSelectableGroupOption(container, nbColumns, subProcess.getLabel(), null,
                                                           compositeProcess.getExternalId(subProcess
                                                               .getExternalId(CompositeProcessConstants.PARAMETER_SELECTED)),
                                                           preferences);
    }
    GridLayout gridLayout = new GridLayout(nbColumns, false);
    group.setLayout(gridLayout);
    return group;
  }

  protected void createSubProcessContent(ICompositeProcess compositeProcess, IProcess subProcess, Composite container)
  {
    for (IParameterDescription<?> parameterDescription : compositeProcess
        .getParameterDescriptionsForSubProcess(subProcess))
    {
      boolean displayParameter = isSubProcessParameterDisplayed(compositeProcess, subProcess, parameterDescription);
      if (displayParameter)
      {
        CreateCompositeParameterDescriptionVisitor visitor = new CreateCompositeParameterDescriptionVisitor();
        visitor.init(container, nbColumns, preferences);
        parameterDescription.accept(visitor);
      }
    }
  }

  protected boolean isSubProcessParameterDisplayed(ICompositeProcess compositeProcess, IProcess subProcess,
      IParameterDescription<?> parameterDescription)
  {
    return !(parameterDescription.getId().equalsIgnoreCase(compositeProcess.getExternalId(subProcess
                                                               .getExternalId(CompositeProcessConstants.PARAMETER_SELECTED))) || parameterDescription
        .getId().equalsIgnoreCase(compositeProcess.getExternalId(subProcess
                                      .getExternalId(ProcessConstants.PARAMETER_GENERATION_DATE))));
  }
}
