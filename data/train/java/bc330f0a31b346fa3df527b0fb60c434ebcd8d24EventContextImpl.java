package com.glennbech.bakemyday.model.event;

import com.glennbech.bakemyday.repository.FormulaRepository;
import com.glennbech.bakemyday.repository.NotificationRepository;
import com.glennbech.bakemyday.repository.RepositoryFactory;
import com.glennbech.bakemyday.repository.UserProfileRepository;

/**
 * Created with IntelliJ IDEA.
 *
 * @author Glenn Bech
 */

public class EventContextImpl implements EventContext {

    public UserProfileRepository getUserProfileRepository() {
        return RepositoryFactory.createUserProfileRepository();
    }

    public FormulaRepository getFormulaRepository() {
        return RepositoryFactory.createFormulaRepository();
    }

    @Override
    public NotificationRepository getNotificationRepository() {
        return RepositoryFactory.createNotificationRepository();
    }
}
