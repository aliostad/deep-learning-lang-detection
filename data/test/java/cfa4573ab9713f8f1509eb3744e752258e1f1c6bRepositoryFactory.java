package org.priorityhealth.stab.pdiff.persistence.repository.factory;

import com.j256.ormlite.support.ConnectionSource;
import org.priorityhealth.stab.pdiff.persistence.repository.asset.AssetRepository;
import org.priorityhealth.stab.pdiff.persistence.repository.asset.NodeRepository;
import org.priorityhealth.stab.pdiff.persistence.repository.profile.IgnoredAreaRepository;
import org.priorityhealth.stab.pdiff.persistence.repository.profile.ProfileRepository;
import org.priorityhealth.stab.pdiff.persistence.repository.profile.StateRepository;
import org.priorityhealth.stab.pdiff.persistence.repository.test.TestRepository;
import org.priorityhealth.stab.pdiff.persistence.repository.test.ResultRepository;

import java.sql.SQLException;

public class RepositoryFactory {

    protected ConnectionSource connectionSource;
    protected AssetRepository assetRepository;
    protected NodeRepository nodeRepository;
    protected StateRepository stateRepository;
    protected ProfileRepository profileRepository;
    protected TestRepository testRepository;
    protected ResultRepository resultRepository;
    protected IgnoredAreaRepository ignoredAreaRepository;


    public RepositoryFactory(ConnectionSource connectionSource) {
        this.connectionSource = connectionSource;
    }

//    public AbstractRepository getInstance(String repositoryName) {
//        String methodName = "get" + repositoryName;
//        try {
//            Method method = this.getClass().getDeclaredMethod(methodName);
//            return (AbstractRepository) method.invoke(null);
//        } catch (NoSuchMethodException ex) {
//            return null;
//        } catch (IllegalAccessException ex) {
//            return null;
//        } catch (InvocationTargetException ex) {
//            return null;
//        } catch (Exception ex) {
//            return null;
//        }
//    }

    public AssetRepository getAssetRepository() throws SQLException {
        if (assetRepository == null) {
            assetRepository = new AssetRepository(connectionSource);
        }
        return assetRepository;
    }

    public NodeRepository getNodeRepository() throws SQLException {
        if (nodeRepository == null) {
            nodeRepository = new NodeRepository(connectionSource);
        }
        return nodeRepository;
    }

    public ProfileRepository getProfileRepository() throws SQLException {
        if (profileRepository == null) {
            profileRepository = new ProfileRepository(connectionSource);
        }
        return profileRepository;
    }

    public StateRepository getStateRepository() throws SQLException {
        if (stateRepository == null) {
            stateRepository = new StateRepository(connectionSource);
        }
        return stateRepository;
    }

    public TestRepository getTestRepository() throws SQLException {
        if (testRepository == null) {
            testRepository = new TestRepository(connectionSource);
        }
        return testRepository;
    }

    public ResultRepository getResultRepository() throws SQLException {
        if (resultRepository == null) {
            resultRepository = new ResultRepository(connectionSource);
        }
        return resultRepository;
    }

    public IgnoredAreaRepository getIgnoredAreaRepository() throws SQLException {
        if (ignoredAreaRepository == null) {
            ignoredAreaRepository = new IgnoredAreaRepository(connectionSource);
        }
        return ignoredAreaRepository;
    }
}
