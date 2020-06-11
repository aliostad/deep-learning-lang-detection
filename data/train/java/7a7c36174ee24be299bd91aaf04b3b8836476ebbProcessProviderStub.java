/*
 * Copyright 2013 University of Washington
 *
 * Licensed under the Educational Community License, Version 1.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.opensource.org/licenses/ecl1.php
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package piecework.persistence.test;

import piecework.common.ViewContext;
import piecework.exception.PieceworkException;
import piecework.model.*;
import piecework.model.Process;
import piecework.persistence.ProcessProvider;
import piecework.security.concrete.PassthroughSanitizer;

/**
 * @author James Renfro
 */
public class ProcessProviderStub implements ProcessProvider {

    private Process process;
    private String processDefinitionKey;
    private Entity principal;

    public ProcessProviderStub() {

    }

    public ProcessProviderStub(Process process, Entity principal) {
        this.process = process;
        this.processDefinitionKey = process != null ? process.getProcessDefinitionKey() : null;
        this.principal = principal;
    }

    @Override
    public piecework.model.Process process() throws PieceworkException {
        return process;
    }

    @Override
    public Process process(ViewContext context) throws PieceworkException {
        return new Process.Builder(process, new PassthroughSanitizer()).build(context);
    }

    @Override
    public String processDefinitionKey() {
        return processDefinitionKey;
    }

    @Override
    public Entity principal() {
        return principal;
    }

    public ProcessProviderStub process(Process process) {
        this.process = process;
        this.processDefinitionKey = process.getProcessDefinitionKey();
        return this;
    }

}
