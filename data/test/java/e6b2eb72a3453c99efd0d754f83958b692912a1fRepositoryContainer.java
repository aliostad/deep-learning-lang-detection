package DAL;

import android.content.Context;

import java.util.HashMap;

/**
 * Created by aykut on 13.4.2015.
 */
// IoC Container
public class RepositoryContainer
{
    private HashMap<Integer, BaseRepository> dependecies;
    private static RepositoryContainer rc = null;
    private Context context;

    private RepositoryContainer(Context context)
    {
        this.context = context;
    }

    public static RepositoryContainer create(Context context)
    {
        if (rc == null)
        {
            rc = new RepositoryContainer(context);
        }
        return rc;
    }

    public BaseRepository getRepository(int repID)
    {
        BaseRepository repository = null;

        switch (repID)
        {
            case RepositoryNames.KATEGORİ_REPOSITORY:
                repository = new KategoriRepository(context);
                break;
            case RepositoryNames.HATIRLATMA_REPOSITORY:
                repository = new HatirlatmaRepository(context);
                break;
        }

        return repository;

    }

}
