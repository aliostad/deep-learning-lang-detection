package com.natswell.sample.ddd.common.domain.model;

public abstract class Validator {

    private ValidationNotificationHandler notificationHandler;

    public Validator(ValidationNotificationHandler notificationHandler) {
        super();
        this.setNotificationHandler(notificationHandler);
    }
    
    public abstract void validate();
    
    protected ValidationNotificationHandler notificationHandler() {
        return this.notificationHandler;
    }
    
    private void setNotificationHandler(ValidationNotificationHandler aHandler) {
        this.notificationHandler = aHandler;
    }
}