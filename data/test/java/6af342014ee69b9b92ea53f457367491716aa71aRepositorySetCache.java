package sk.stuba.fiit.perconik.activity.listeners.git;

import org.eclipse.jgit.lib.Repository;

final class RepositorySetCache<E> {
  private static final Object key = new Object();

  private final RepositoryMapCache<Object, E> map;

  RepositorySetCache() {
    this.map = new RepositoryMapCache<>();
  }

  boolean load(final Repository repository, final E value) {
    return this.map.load(repository, key, value);
  }

  E update(final Repository repository, final E value) {
    return this.map.update(repository, key, value);
  }

  @Override
  public String toString() {
    return this.map.toString();
  }
}
