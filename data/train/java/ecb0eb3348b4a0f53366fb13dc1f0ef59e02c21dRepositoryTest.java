package nut.model;

import static org.testng.Assert.*;
import org.testng.annotations.Test;

public class RepositoryTest
{

    @Test
    public void testHashCodeNullSafe()
    {
        new Repository().hashCode();
    }

    @Test
    public void testEqualsNullSafe()
    {
        assertNotNull( new Repository() );
    }

    @Test
    public void testEqualsIdentity()
    {
        Repository repository = new Repository();
        assertTrue( repository.equals( repository ) );
    }

    @Test
    public void testToStringNullSafe()
    {
        assertNotNull( new Repository().toString() );
    }

    @Test
    public void testName()
    {
      String s = "test_repository";
      Repository repository = new Repository();
      repository.setName( s );
      assertEquals( repository.getName(), s );
    }

    @Test
    public void testLayout()
    {
      String s = "maven";
      Repository repository = new Repository();
      // Default layout is 'nut'
      assertEquals( repository.getLayout(), "nut" );
      repository.setLayout( s );
      assertEquals( repository.getLayout(), s );
    }

    @Test
    public void testURL()
    {
      String s = "test_url";
      Repository repository = new Repository();
      // Default url is null
      assertNull( repository.getURL() );
      repository.setURL( s );
      assertEquals( repository.getURL(), s );
    }

    @Test(expectedExceptions = ValidationException.class)
    public void testValidationExceptionNullName() throws ValidationException
    {
      Repository repository = new Repository();
      repository.setURL( "http://repo" );
      repository.validate( );
    }

    @Test(expectedExceptions = ValidationException.class)
    public void testValidationExceptionEmptyName() throws ValidationException
    {
      Repository repository = new Repository();
      repository.setName( "" );
      repository.setURL( "http://repo" );
      repository.validate( );
    }

    @Test(expectedExceptions = ValidationException.class)
    public void testValidationExceptionNullURL() throws ValidationException
    {
      Repository repository = new Repository();
      repository.setName( "repo" );
      repository.validate( );
    }

    @Test(expectedExceptions = ValidationException.class)
    public void testValidationExceptionEmptyURL() throws ValidationException
    {
      Repository repository = new Repository();
      repository.setName( "repo" );
      repository.setURL( "" );
      repository.validate( );
    }

    @Test(expectedExceptions = ValidationException.class)
    public void testValidationExceptionNullLayout() throws ValidationException
    {
      Repository repository = new Repository();
      repository.setName( "repo" );
      repository.setURL( "http://repo" );
      repository.setLayout( null );
      repository.validate( );
    }

    @Test(expectedExceptions = ValidationException.class)
    public void testValidationExceptionEmptyLayout() throws ValidationException
    {
      Repository repository = new Repository();
      repository.setName( "repo" );
      repository.setURL( "http://repo" );
      repository.setLayout( "" );
      repository.validate( );
    }

}
