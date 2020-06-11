package util.container;

import java.util.Collection;

import api.repository.ApplicationRepositoryImpl;
import api.repository.CodeRepositoryImpl;
import api.repository.IdTokenRepositoryImpl;
import api.repository.TokenRepositoryImpl;

public final class RepositoryContainer extends Container
{
  
  private RepositoryContainer()
  {
    super();
  }
  
  @Override
  protected void initBinding()
  {
    add(ApplicationRepositoryImpl.getInstance());
    add(CodeRepositoryImpl.getInstance());
    add(IdTokenRepositoryImpl.getInstance());
    add(TokenRepositoryImpl.getInstance());
  }
  
  public static <T> T get(Class<T> repository)
  {
    return Holder.SINGLETON.getBind(repository);
  }
  
  public static Collection<?> getRepositories()
  {
    return Holder.SINGLETON.getListService();
  }
  
  private static class Holder
  {
    private static final RepositoryContainer SINGLETON = new RepositoryContainer();
  }
  
}
