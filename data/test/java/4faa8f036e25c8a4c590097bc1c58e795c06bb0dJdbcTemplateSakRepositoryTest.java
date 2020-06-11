package no.knowit.backtobasics.repository;

import static org.junit.Assert.*;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

public class JdbcTemplateSakRepositoryTest extends SakRepositoryTest {

    private JdbcTemplateSakRepository sakRepository;
    
    @Override
    protected SakRepository getSakRepository() {
        return sakRepository;
    }

    @Before
    public void initierSakRepository() {
        sakRepository = new JdbcTemplateSakRepository();
        // TODO opprett skjema
    }
    
    @After
    public void taNedSakRepository() {
        // TODO ta ned database
    }
    
}
