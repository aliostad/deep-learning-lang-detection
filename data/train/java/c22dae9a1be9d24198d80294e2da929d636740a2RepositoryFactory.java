package ch.heigvd.movies.interfaces;

/*
 * Generic class for repository creation by reflection
 * */
public class RepositoryFactory 
{
	static IMovieRepository repository = null;
		
	public static IMovieRepository getRepository(String classFullName)
	{
		if (repository == null)
		{
			Class<?> repositoryClass = null;
			try 
			{
				repositoryClass = Class.forName(classFullName);
				repository = (IMovieRepository)repositoryClass.newInstance();				
			} 
			catch (Exception e) 
			{				
				e.printStackTrace();
			}		
		}
		
		return repository;		
	}
}
