package se.ticket.relnotes.git.github.domain;


public class Commit {
    private Author author;
    private String message;
    private Repository repository;

    public Author getAuthor() {
        return author;
    }

    public void setAuthor(Author author) {
        this.author = author;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public void setRepository(Repository repository) {
        this.repository = repository;
    }

    public Repository getRepository() {
        return repository;
    }
}
