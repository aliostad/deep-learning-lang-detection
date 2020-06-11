package org.survey;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;
import org.survey.model.user.UserComparatorTest;
import org.survey.model.user.UserTest;
import org.survey.repository.file.FileRepositoryJPATest;
import org.survey.repository.file.FileRepositoryTest;
import org.survey.repository.poll.PollRepositoryJPATest;
import org.survey.repository.user.UserRepositoryJPATest;
import org.survey.repository.user.UserRepositoryTest;

@RunWith(Suite.class)
@Suite.SuiteClasses({
    UserTest.class,
    UserComparatorTest.class,
    UserRepositoryTest.class,
    UserRepositoryJPATest.class,
    FileRepositoryTest.class,
    FileRepositoryJPATest.class,
    PollRepositoryJPATest.class,
})
public class RepositoryTestSuite {

}
