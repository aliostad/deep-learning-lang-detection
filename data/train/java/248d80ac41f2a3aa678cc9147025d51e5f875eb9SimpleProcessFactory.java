package net.rambaldi.process;

import static java.util.Objects.*;

final class SimpleProcessFactory
    implements ProcessFactory
{

    private final ProcessBuilder builder;

    SimpleProcessFactory(ProcessBuilder builder) {
        this.builder = requireNonNull(builder);
    }

    @Override
    public Process newInstance() throws ProcessCreationException {
        try {
            Process process = builder.start();
            return process;
        } catch (Exception e) {
            throw new ProcessCreationException(e);
        }
    }
}
