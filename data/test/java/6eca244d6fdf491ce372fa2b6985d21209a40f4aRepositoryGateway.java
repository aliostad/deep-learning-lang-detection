package com.nhaarman.trinity.internal.codegen.data;

import org.jetbrains.annotations.NotNull;

/**
 * A gateway class which holds several repository classes.
 */
public class RepositoryGateway {

  @NotNull
  private final SerializerClassRepository mSerializerClassRepository;

  @NotNull
  private final TableClassRepository mTableClassRepository;

  @NotNull
  private final ColumnMethodRepository mColumnMethodRepository;

  @NotNull
  private final RepositoryClassRepository mRepositoryClassRepository;

  public RepositoryGateway() {
    mSerializerClassRepository = new SerializerClassRepository();
    mTableClassRepository = new TableClassRepository();
    mColumnMethodRepository = new ColumnMethodRepository();
    mRepositoryClassRepository = new RepositoryClassRepository();
  }

  @NotNull
  public SerializerClassRepository getSerializerClassRepository() {
    return mSerializerClassRepository;
  }

  @NotNull
  public TableClassRepository getTableClassRepository() {
    return mTableClassRepository;
  }

  @NotNull
  public ColumnMethodRepository getColumnMethodRepository() {
    return mColumnMethodRepository;
  }

  @NotNull
  public RepositoryClassRepository getRepositoryClassRepository() {
    return mRepositoryClassRepository;
  }
}
