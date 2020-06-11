package gitoscope.domain;

import org.eclipse.jgit.lib.Repository;

import java.io.File;
import java.util.Date;

public class Project {

    private final Repository repository;
    private final String name;

    public Project(String name, Repository repository) {
        this.repository = repository;
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public Person getOwner() {
        return null;
    }

    public Date getLastModified() {
        return new Date(repository.getDirectory().lastModified());
    }

    public Repository getRepository() {
        return repository;
    }
}
