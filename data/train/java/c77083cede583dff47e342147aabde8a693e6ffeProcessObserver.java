package com.github.okapies.rx.process;

import rx.Observer;

public class ProcessObserver<T> {

    private final Observer<ProcessOutput<T>> stdout;

    private final Observer<ProcessOutput<T>> stderr;

    public ProcessObserver() {
        this(null, null);
    }

    public ProcessObserver(Observer<ProcessOutput<T>> stdout, Observer<ProcessOutput<T>> stderr) {
        this.stdout = stdout;
        this.stderr = stderr;
    }

    public Observer<ProcessOutput<T>> stdout() {
        return this.stdout;
    }

    public ProcessObserver<T> stdout(Observer<ProcessOutput<T>> stdout) {
        return new ProcessObserver<>(stdout, this.stderr);
    }

    public Observer<ProcessOutput<T>> stderr() {
        return this.stderr;
    }

    public ProcessObserver<T> stderr(Observer<ProcessOutput<T>> stderr) {
        return new ProcessObserver<>(this.stderr, stderr);
    }

}
