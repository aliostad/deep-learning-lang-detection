package org.jtwig.plugins.bintray.model;

public class BintrayPackage {
    private final BintrayRepository repository;
    private final String packageName;

    public BintrayPackage(BintrayRepository repository, String packageName) {
        this.repository = repository;
        this.packageName = packageName;
    }

    public String getPath() {
        return repository.getPath() + "/" + packageName;
    }

    public String getName() {
        return packageName;
    }

    public BintrayRepository getRepository() {
        return repository;
    }
}
