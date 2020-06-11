package Model;

import com.sun.istack.internal.NotNull;

/**
 * Standard singleton design pattern
 */
public class HashRepositoryFactory {

    /*
    * The default storage for the hashes related to the algorithm
    * */
    private static HashRepository hashRepository =null;
    private HashRepositoryFactory(){
    }
    public static HashRepository getInstance(){
        return hashRepository;
    }
    public static HashRepository getInstance(@NotNull Backend backend){
        if(hashRepository ==null){
            switch (backend) {
                case SQLite:
                    hashRepository = new SQliteHashRepository();
                    break;
                case H2:
                    hashRepository = new H2HashRepository();
                    break;
                case HashSet:
                    hashRepository = new SetHashRepository();
                    break;
            }
        }

        return hashRepository;
    }

}
