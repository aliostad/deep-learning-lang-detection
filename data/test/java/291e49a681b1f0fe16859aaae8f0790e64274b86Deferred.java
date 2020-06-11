package com.puzheng.deferred;

/**
 * Created by xc on 16-1-14.
 */
public class Deferred<DataType, ErrorType> implements Deferrable<DataType, ErrorType> {


    private DoneHandler<DataType> doneHandler;
    private FailHandler<ErrorType> failHandler;
    private AlwaysHandler alwaysHandler;

    public Deferrable<DataType, ErrorType> done(DoneHandler<DataType> doneHandler) {
        this.doneHandler = doneHandler;
        return this;
    }

    public Deferrable<DataType, ErrorType> fail(FailHandler<ErrorType> failHandler) {
        this.failHandler = failHandler;
        return this;
    }

    public Deferrable<DataType, ErrorType> always(AlwaysHandler alwaysHandler) {
        this.alwaysHandler = alwaysHandler;
        return this;
    }

    @Override
    public void resolve(DataType data) {
        if (doneHandler != null) {
            doneHandler.done(data);
        }
        if (alwaysHandler != null) {
            alwaysHandler.always();
        }
    }

    @Override
    public void reject(ErrorType err) {
        if (failHandler != null) {
            failHandler.fail(err);
        }
        if (alwaysHandler != null) {
            alwaysHandler.always();
        }
    }

}
