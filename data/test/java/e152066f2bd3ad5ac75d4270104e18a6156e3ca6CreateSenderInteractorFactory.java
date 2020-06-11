package io.kindstrom.senderremote.domain.interactor.factory;

import java.util.List;

import javax.inject.Inject;

import io.kindstrom.senderremote.domain.interactor.CreateSenderInteractor;
import io.kindstrom.senderremote.domain.model.Sender;
import io.kindstrom.senderremote.domain.repository.CommandRepository;
import io.kindstrom.senderremote.domain.repository.GroupMemberRepository;
import io.kindstrom.senderremote.domain.repository.InputRepository;
import io.kindstrom.senderremote.domain.repository.OutputRepository;
import io.kindstrom.senderremote.domain.repository.SenderRepository;

public class CreateSenderInteractorFactory {
    private final SenderRepository senderRepository;
    private final InputRepository inputRepository;
    private final OutputRepository outputRepository;
    private final CommandRepository commandRepository;
    private final GroupMemberRepository groupMemberRepository;

    @Inject
    public CreateSenderInteractorFactory(SenderRepository senderRepository, InputRepository inputRepository, OutputRepository outputRepository, CommandRepository commandRepository, GroupMemberRepository groupMemberRepository) {
        this.senderRepository = senderRepository;
        this.inputRepository = inputRepository;
        this.outputRepository = outputRepository;
        this.commandRepository = commandRepository;
        this.groupMemberRepository = groupMemberRepository;
    }

    public CreateSenderInteractor create(Sender sender, List<Integer> groups) {
        return new CreateSenderInteractor(senderRepository, inputRepository, outputRepository, commandRepository, groupMemberRepository, sender, groups);
    }
}
