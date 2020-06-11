package net.codjo.dataprocess.server.handlerhelper;
import net.codjo.dataprocess.common.exception.TreatmentException;
import net.codjo.dataprocess.server.dao.RepositoryDao;
import net.codjo.dataprocess.server.repository.Repository;
import net.codjo.mad.server.handler.HandlerException;
import java.sql.Connection;
import java.sql.SQLException;
/**
 *
 */
public class RepositoryHandlerHelper {
    private RepositoryHandlerHelper() {
    }


    public static void renameRepository(Connection con, int repositoryId, String repositoryName)
          throws SQLException, HandlerException {
        RepositoryDao repositoryDao = new RepositoryDao();
        repositoryDao.renameRepository(con, repositoryId, repositoryName);
    }


    public static void reinitializeRepositoryCache() {
        Repository.reinitializeRepositoryCache();
    }


    public static String getRepositoryContent(Connection con, int repositoryId) throws SQLException {
        return Repository.getRepositoryContent(con, repositoryId);
    }


    public static void deleteRepository(Connection con, int repositoryId) throws SQLException {
        RepositoryDao repositoryDao = new RepositoryDao();
        repositoryDao.deleteRepository(con, repositoryId);
    }


    public static String newRepository(Connection con, String repositoryName) throws SQLException {
        RepositoryDao repositoryDao = new RepositoryDao();
        return repositoryDao.newRepository(con, repositoryName);
    }


    public static String updateRepository(Connection con, int repositoryId, String content)
          throws SQLException, TreatmentException {
        RepositoryDao repositoryDao = new RepositoryDao();
        return repositoryDao.updateRepository(con, repositoryId, content);
    }


    public static int getRepositoryIdFromName(Connection con, String repositoryName)
          throws SQLException, TreatmentException {
        RepositoryDao repositoryDao = new RepositoryDao();
        return repositoryDao.getRepositoryIdFromName(con, repositoryName);
    }
}
