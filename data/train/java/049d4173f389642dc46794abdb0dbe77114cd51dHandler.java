package net.ilexiconn.magister.handler;

public abstract class Handler<HANDLER extends IHandler> {
    public abstract Class<HANDLER> getHandler();

    public static final Handler<AppointmentHandler> APPOINTMENT = new Handler<AppointmentHandler>() {
        @Override
        public Class<AppointmentHandler> getHandler() {
            return AppointmentHandler.class;
        }
    };

    public static final Handler<ContactHandler> CONTACT = new Handler<ContactHandler>() {
        @Override
        public Class<ContactHandler> getHandler() {
            return ContactHandler.class;
        }
    };

    public static final Handler<ELOHandler> ELO = new Handler<ELOHandler>() {
        @Override
        public Class<ELOHandler> getHandler() {
            return ELOHandler.class;
        }
    };

    public static final Handler<GradeHandler> GRADE = new Handler<GradeHandler>() {
        @Override
        public Class<GradeHandler> getHandler() {
            return GradeHandler.class;
        }
    };

    public static final Handler<MessageHandler> MESSAGE = new Handler<MessageHandler>() {
        @Override
        public Class<MessageHandler> getHandler() {
            return MessageHandler.class;
        }
    };

    public static final Handler<PasswordHandler> PASSWORD = new Handler<PasswordHandler>() {
        @Override
        public Class<PasswordHandler> getHandler() {
            return PasswordHandler.class;
        }
    };

    public static final Handler<PresenceHandler> PRESENCE = new Handler<PresenceHandler>() {
        @Override
        public Class<PresenceHandler> getHandler() {
            return PresenceHandler.class;
        }
    };
}
