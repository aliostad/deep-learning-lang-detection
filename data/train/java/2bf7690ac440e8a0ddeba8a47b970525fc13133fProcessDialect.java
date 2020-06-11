package org.drools.process.builder.dialect;

import org.drools.process.builder.ActionBuilder;
import org.drools.process.builder.ProcessBuildContext;
import org.drools.process.builder.ProcessClassBuilder;
import org.drools.process.builder.ReturnValueEvaluatorBuilder;

public interface ProcessDialect {

    ActionBuilder getActionBuilder();

    ReturnValueEvaluatorBuilder getReturnValueEvaluatorBuilder();

    ProcessClassBuilder getProcessClassBuilder();

    void addProcess(final ProcessBuildContext context);

}
