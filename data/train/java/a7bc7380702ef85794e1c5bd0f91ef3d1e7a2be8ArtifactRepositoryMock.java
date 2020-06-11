/*
 * Team : AGF AM / OSI / SI / BO
 *
 * Copyright (c) 2001 AGF Asset Management.
 */
package net.codjo.maven.mojo.datagen;
import org.apache.maven.artifact.repository.DefaultArtifactRepository;
import org.apache.maven.artifact.repository.layout.DefaultRepositoryLayout;
/**
 *
 */
public class ArtifactRepositoryMock extends DefaultArtifactRepository {
    public ArtifactRepositoryMock() {
        super("mock", MockUtil.toUrl("./target/localRepository"),
              new DefaultRepositoryLayout());
    }
}
