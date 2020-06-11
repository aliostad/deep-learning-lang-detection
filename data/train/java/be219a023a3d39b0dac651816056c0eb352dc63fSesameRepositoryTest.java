package dk.roadstead.stash.repository;

import org.junit.Test;

/**
 * User: kevon
 * Date: 21/04/11
 */
public class SesameRepositoryTest {
    @Test
    public void dumpVideoGraph() throws Exception {
        VideoRepository repository = new VideoRepository();
        repository.dumpGraph(VideoRepository.VIDEO_REPO_ID);
    }

    @Test
    public void dumpUserGraph() throws Exception {
        VideoRepository repository = new VideoRepository();
        repository.dumpGraph(UserRepository.USER_REPO_ID);
    }
}
