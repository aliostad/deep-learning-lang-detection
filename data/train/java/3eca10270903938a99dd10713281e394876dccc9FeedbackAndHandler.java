package be.witspirit.mathex.textui;

/**
 * Container for the tuple - Feedback & CommandHandler
 */
public class FeedbackAndHandler {
    private String feedback;
    private CommandHandler commandHandler;

    public FeedbackAndHandler(String feedback, CommandHandler commandHandler) {
        this.feedback = feedback;
        this.commandHandler = commandHandler;
    }

    public String getFeedback() {
        return feedback;
    }

    public CommandHandler getCommandHandler() {
        return commandHandler;
    }
}
