package com.englishtown.vertx.cassandra.binarystore;

import io.vertx.core.Handler;
import io.vertx.core.buffer.Buffer;
import io.vertx.core.streams.ReadStream;

/**
 * Default implementation of {@link com.englishtown.vertx.cassandra.binarystore.FileReader}
 */
public class FileReader implements ReadStream<Buffer> {

    public enum Result {
        OK,
        NOT_FOUND,
        ERROR
    }

    private Handler<FileReadInfo> fileHandler;
    private Handler<Buffer> dataHandler;
    private Handler<Void> endHandler;
    private Handler<Result> resultHandler;
    private Handler<Throwable> exceptionHandler;

    private boolean paused;
    private Handler<Void> resumeHandler;

    public FileReader fileHandler(Handler<FileReadInfo> handler) {
        fileHandler = handler;
        return this;
    }

    /**
     * Set a data handler. As data is read, the handler will be called with the data.
     *
     * @param handler
     */
    @Override
    public FileReader handler(Handler<Buffer> handler) {
        this.dataHandler = handler;
        return this;
    }

    /**
     * Pause the {@code ReadSupport}. While it's paused, no data will be sent to the {@code dataHandler}
     */
    @Override
    public FileReader pause() {
        paused = true;
        return this;
    }

    /**
     * Resume reading. If the {@code ReadSupport} has been paused, reading will recommence on it.
     */
    @Override
    public FileReader resume() {
        paused = false;
        if (resumeHandler != null) {
            Handler<Void> handler = resumeHandler;
            resumeHandler = null;
            handler.handle(null);
        }
        return this;
    }

    @Override
    public FileReader endHandler(Handler<Void> handler) {
        endHandler = handler;
        return this;
    }

    public FileReader resultHandler(Handler<Result> handler) {
        resultHandler = handler;
        return this;
    }

    @Override
    public FileReader exceptionHandler(Handler<Throwable> handler) {
        exceptionHandler = handler;
        return this;
    }

    public void handleFile(FileReadInfo fileInfo) {
        if (fileHandler != null) {
            fileHandler.handle(fileInfo);
        }
    }

    public void handleData(byte[] data) {
        handleData(Buffer.buffer(data));
    }

    public void handleData(Buffer data) {
        if (dataHandler != null) {
            dataHandler.handle(data);
        }
    }

    public void handleEnd(Result result) {
        if (resultHandler != null) {
            resultHandler.handle(result);
        }
        if (endHandler != null) {
            endHandler.handle(null);
        }
    }

    public void handleException(Throwable t) {
        if (exceptionHandler != null) {
            exceptionHandler.handle(t);
        }
    }

    public boolean isPaused() {
        return paused;
    }

    public void resumeHandler(Handler<Void> handler) {
        resumeHandler = handler;
    }
}
