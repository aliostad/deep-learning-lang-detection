package edu.csudh.cs.se.p2.applet;

import edu.csudh.cs.se.p1.applet.KWRotator;
import edu.csudh.cs.se.p2.repository.KwicRepository;
import edu.csudh.cs.se.p2.repository.KwicRepositoryImpl;
import edu.csudh.cs.se.p2.repository.UrlRepository;
import edu.csudh.cs.se.p2.repository.UrlRepositoryFileImpl;
import edu.csudh.cs.se.p2.service.IndexSearchMapImplKw;
import edu.csudh.cs.se.p2.service.IndexSearcher;

public final class MicrominerContainer {

    private static UrlRepository repository;
    
    private static KWRotator rotator;    
    
    private static IndexSearcher searcher;
    
    private static KwicRepository kwicRepository;

    static{
        repository = new UrlRepositoryFileImpl();
        rotator = new KWRotator();
        searcher = new IndexSearchMapImplKw(repository, rotator);
        kwicRepository = new KwicRepositoryImpl();
    }
    private MicrominerContainer(){
    }
    
    public static UrlRepository getRepository(){
        return repository;
    }
    
    
    public static KWRotator getRotator(){
        return rotator;
    }
    
    
    public static IndexSearcher getSearcher(){
        return searcher;
    }
    
    public static KwicRepository getKwicRepository(){
        return kwicRepository;
    }
}
