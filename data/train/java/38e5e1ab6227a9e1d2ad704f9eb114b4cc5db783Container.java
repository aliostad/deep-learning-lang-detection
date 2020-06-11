package de.objektkontor.wsc.container.core;


public class Container {

    private final Repository repository = new Repository();

    public boolean execute(Transaction transaction) {
        synchronized (repository) {
            try {
                RepositoryTransaction content = new RepositoryTransaction(repository);
                transaction.prepare(content);
                return content.commit();
            } finally {
                repository.notifyAll();
            }
        }
    }

    public void run() throws InterruptedException {
        synchronized (repository) {
            while (! repository.empty())
                repository.wait();
        }
    }

    public void destroy() {
    }
}
