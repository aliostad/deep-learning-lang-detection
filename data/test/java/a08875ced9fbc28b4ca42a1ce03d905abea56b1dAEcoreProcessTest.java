package org.benhur.process.ecore.test;

import java.util.Date;

import org.benhur.process.ecore.EcoreProcess;
import org.benhur.process.emf.acceleo.AcceleoModel2FileProcessConstants;
import org.benhur.process.emf.impl.Model2FileProcessConstants;
import org.benhur.process.impl.CompositeProcessConstants;
import org.benhur.process.impl.ProcessConstants;
import org.benhur.process.parameter.IParameters;
import org.benhur.process.test.AProcessTest;

public abstract class AEcoreProcessTest extends AProcessTest<EcoreProcess>
{
  protected String modelname = null;

  public AEcoreProcessTest(String modelname)
  {
    super(new EcoreProcess());
    this.modelname = modelname;
  }

  @Override
  protected void prepareParameters(IParameters parameters)
  {
    super.prepareParameters(parameters);
    parameters.setParameter(process.getParameterDescription(process
        .getExternalId(ProcessConstants.PARAMETER_GENERATION_DATE)), new Date(0));
    parameters.setParameter(process.getParameterDescription(process
        .getExternalId(Model2FileProcessConstants.PARAMETER_MODEL_INPUT_FILE)), "resources/input/" + modelname
        + ".ecore");
    parameters.setParameter(process.getParameterDescription(process
        .getExternalId(Model2FileProcessConstants.PARAMETER_MODEL_VALIDATION_STRUCTURE_AND_CONSTRAINTS)), Boolean.TRUE);
    parameters.setParameter(process.getParameterDescription(process.getExternalId("ecore2c."
                                + CompositeProcessConstants.PARAMETER_SELECTED)), Boolean.TRUE);
    parameters.setParameter(process.getParameterDescription(process.getExternalId("ecore2c."
                                + AcceleoModel2FileProcessConstants.PARAMETER_TARGET_FOLDER)), "resources/output/"
                                + modelname + "/c");
    parameters.setParameter(process.getParameterDescription(process.getExternalId("ecore2java."
                                + CompositeProcessConstants.PARAMETER_SELECTED)), Boolean.TRUE);
    parameters.setParameter(process.getParameterDescription(process.getExternalId("ecore2java."
                                + AcceleoModel2FileProcessConstants.PARAMETER_TARGET_FOLDER)), "resources/output/"
                                + modelname + "/java");
  }
}
