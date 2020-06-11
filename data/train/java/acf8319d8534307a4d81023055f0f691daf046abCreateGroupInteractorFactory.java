package io.kindstrom.senderremote.domain.interactor.factory;

import javax.inject.Inject;

import io.kindstrom.senderremote.domain.interactor.CreateGroupInteractor;
import io.kindstrom.senderremote.domain.model.Group;
import io.kindstrom.senderremote.domain.repository.GroupMemberRepository;
import io.kindstrom.senderremote.domain.repository.GroupRepository;

public class CreateGroupInteractorFactory {
    private final GroupRepository groupRepository;
    private final GroupMemberRepository groupMemberRepository;

    @Inject
    public CreateGroupInteractorFactory(GroupRepository groupRepository, GroupMemberRepository groupMemberRepository) {
        this.groupRepository = groupRepository;
        this.groupMemberRepository = groupMemberRepository;
    }

    public CreateGroupInteractor create(Group group) {
        return new CreateGroupInteractor(groupRepository, groupMemberRepository, group);
    }
}
