/**
 * 
 */
package org.jocean.cli;


/**
 * @author Marvin.Ma
 *
 */
public abstract class AbstractCliContext implements CliContext {

    private CommandRepository   commandRepository;
    
    /* (non-Javadoc)
     * @see stc.skymobi.cli.CliContext#getCommandRepository()
     */
    public CommandRepository getCommandRepository() {
        return commandRepository;
    }

    /**
     * @param commandRepository the commandRepository to set
     */
    public void setCommandRepository(final CommandRepository commandRepository) {
        this.commandRepository = commandRepository;
    }
}
