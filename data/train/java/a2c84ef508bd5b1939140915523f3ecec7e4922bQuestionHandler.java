package org.injustice.squares.handlers;

import org.injustice.squares.mechanics.DrawChart;

/**
 * Created by Azmat on 01/04/2014.
 */
@SuppressWarnings("DefaultFileTemplate")
public class QuestionHandler {
    private final Handler handler;
    public QuestionHandler(Handler handler) {
        this.handler = handler;
    }

    public void setCorrect(int attempts) {
        if (attempts != 1) {
            handler.getDataHandler().negateCorrect();
            System.out.println("Negating attempts");
        }
        handler.getDataHandler().getAnswered().add(handler.getDataHandler().getFrame().getNumber());
        handler.getDataHandler().getAttempts().putIfAbsent(handler.getDataHandler().getFrame().getNumber(), attempts);
        final long time = System.currentTimeMillis() - handler.getDataHandler().getStartQuestionTime().longValue();
        handler.getDataHandler().setStartQuestionTime(System.currentTimeMillis());
        handler.getDataHandler().getTimeTakenMap().putIfAbsent(handler.getDataHandler().getFrame().getNumber(), time);
        if (handler.getDataHandler().getAnswered().size() == handler.getDataHandler().getTotalNumberQuestions().intValue()) {
            handler.validateFinished();
            DrawChart chart = new DrawChart(handler.getDataHandler().getTimeTakenMap(), handler.getComputer(), handler.getDataHandler().getAttempts());
            handler.getUiHandler().checkRetry(chart);
            return;
        }
        final Integer number = generateNumber();
        if (!handler.getDataHandler().getAnswered().contains(number) && handler.getDataHandler().getGenerated().contains(number)) {
            handler.getDataHandler().getFrame().setQuestion(number);
        }
        handler.validateFinished();
    }

    public Integer generateNumber() {
        Integer number = handler.getDataHandler().getRandom().nextInt(handler.getDataHandler().getTotalNumberQuestions().intValue() + 1);
        return !handler.getDataHandler().getGenerated().contains(number) && number != 0 ? addToList(number) : generateNumber();
    }

    private Integer addToList(Integer number) {
        handler.getDataHandler().getGenerated().add(number);
        return number;
    }
}
