package infrastructure;

import infrastructure.repository.BoardRepository;
import infrastructure.repository.ConfigurationRepository;
import infrastructure.repository.UserRepository;

/**
 * Author: Jirka Pénzeš
 * Date: 7.12.12
 * Time: 23:51
 */
public class DatabaseContext {

    private BoardRepository boardRepository;
    private UserRepository userRepository;
    private ConfigurationRepository configurationRepository;

    public DatabaseContext(BoardRepository boardRepository, UserRepository userRepository, ConfigurationRepository configurationRepository) {
        this.boardRepository = boardRepository;
        this.userRepository = userRepository;
        this.configurationRepository = configurationRepository;
    }

    public BoardRepository getBoardRepository() {
        return boardRepository;
    }

    public UserRepository getUserRepository() {
        return userRepository;
    }

    public ConfigurationRepository getConfigurationRepository() {
        return configurationRepository;
    }
}
