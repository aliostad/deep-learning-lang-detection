package com.cdi.scope;

import com.cdi.scope.handler.ApplicationScopeHandler;
import com.cdi.scope.handler.ConversationScopeHandler;
import com.cdi.scope.handler.RequestScopeHandler;
import com.cdi.scope.handler.ScopeHandler;
import com.cdi.scope.handler.SessionScopeHandler;
import com.cdi.scope.handler.SingletonScopeHandler;


public enum ScopeType {

    SINGLETON() {
        @Override
        public ScopeHandler getHandler() {
            return new SingletonScopeHandler();
        }
    },
    APPLICATION() {
        @Override
        public ScopeHandler getHandler() {
            return new ApplicationScopeHandler();
        }
    },
    CONVERSATION {
        @Override
        public ScopeHandler getHandler() {
            return new ConversationScopeHandler();
        }
    },
    SESSION {
        @Override
        public ScopeHandler getHandler() {
            return new SessionScopeHandler();
        }
    },
    REQUEST {
        @Override
        public ScopeHandler getHandler() {
            return new RequestScopeHandler();
        }
    };
    
    public abstract ScopeHandler getHandler();
    
}