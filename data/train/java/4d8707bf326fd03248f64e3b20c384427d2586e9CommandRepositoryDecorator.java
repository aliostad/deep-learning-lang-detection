package com.hdbandit.commandframework.model.impl;

import com.hdbandit.commandframework.model.CommandRepository;

/**
 * Created by gerard on 16/6/15.
 */
public abstract class CommandRepositoryDecorator<T> extends  AbstractCommandRepository<T> implements CommandRepository<T> {

    private CommandRepository<T> commandRepository;

    public CommandRepository<T> getCommandRepository() {
        return commandRepository;
    }

    public void setCommandRepository(CommandRepository<T> commandRepository) {
        if (commandRepository == null) {
            throw new NullPointerException("Command repository cannot be null");
        }
        this.commandRepository = commandRepository;
    }
}
