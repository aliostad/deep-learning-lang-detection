package org.benhur.process.emf.impl;

import java.util.List;

import org.benhur.process.emf.IFile2ModelProcess;
import org.benhur.process.emf.IModel2FileProcess;
import org.benhur.utility.emf.validation.custom.IEMFModelCustomValidator;

public class File2Model2FileCompositeModelProcess extends AModel2FileCompositeProcess
{
  protected final IFile2ModelProcess file2ModelProcess;
  protected final List<IModel2FileProcess> model2FileProcesses;

  public File2Model2FileCompositeModelProcess(String id, String label, String description,
                                    IFile2ModelProcess file2ModelProcess,
                                    List<IModel2FileProcess> model2FileProcesses, String modelFileExtension,
                                    IEMFModelCustomValidator validator)
  {
    super(id, label, description, modelFileExtension, validator);
    this.file2ModelProcess = file2ModelProcess;
    this.model2FileProcesses = model2FileProcesses;
  }

  @Override
  protected void declareSubProcesses()
  {
    addSubProcess(file2ModelProcess, true);
    for (IModel2FileProcess model2FileProcess : model2FileProcesses)
    {
      addSubProcess(model2FileProcess, false);
    }
  }
}
