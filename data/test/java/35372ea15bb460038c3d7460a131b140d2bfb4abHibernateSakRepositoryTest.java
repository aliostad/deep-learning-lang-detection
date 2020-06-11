package no.knowit.backtobasics.repository;

import org.junit.After;
import org.junit.Before;

public class HibernateSakRepositoryTest extends SakRepositoryTest {

    private HibernateSakRepository sakRepository;
    
    @Override
    protected SakRepository getSakRepository() {
        return sakRepository;
    }
    
    @Before
    public void initierSakRepository() {
        sakRepository = new HibernateSakRepository();
    }
    
    @After
    public void taNedSakRepository() {
        sakRepository.taNedSakRepository();
    }
    
}
