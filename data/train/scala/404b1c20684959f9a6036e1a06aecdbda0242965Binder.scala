package ru.maxkar.reactive.deps

import ru.maxkar.reactive.Disposable


/**
 * Interface for all items used to set dependencies between elements.
 * Could manage lifetime of bindings by removing them.
 */
trait Binder {
  /**
   * Binds an item to the dependency list and returns a destructor for the newly
   * established dependency.
   * @param T object type.
   * @param list dependency list to bind item with.
   * @param item item to bind with the list.
   * @return dependency destructor for the established dependency.
   */
  def bind[T](list : DependencyList[T], item : T) : Disposable




  /**
   * Creates a "nested" binder. That binder could be disposed by calling a
   * disporer's <code>dispose</code> method. All children binders must be
   * disposed when <code>this</code> disposer is disposed.
   */
  def sub() : (Binder, Disposable)
}
