package io.kindstrom.senderremote.domain.interactor;

import android.support.annotation.NonNull;

import java.util.List;

import javax.inject.Inject;
import javax.inject.Named;

import io.kindstrom.senderremote.domain.model.Command;
import io.kindstrom.senderremote.domain.model.Port;
import io.kindstrom.senderremote.domain.model.Sender;
import io.kindstrom.senderremote.domain.repository.CommandRepository;
import io.kindstrom.senderremote.domain.repository.InputRepository;
import io.kindstrom.senderremote.domain.repository.OutputRepository;
import io.kindstrom.senderremote.domain.repository.SenderRepository;

public class GetSenderInteractor implements Interactor<Sender> {
    private final int senderId;
    private final SenderRepository senderRepository;
    private final InputRepository inputRepository;
    private final OutputRepository outputRepository;
    private final CommandRepository commandRepository;

    @Inject
    public GetSenderInteractor(@Named("senderId") int senderId,
                               @NonNull SenderRepository senderRepository,
                               @NonNull InputRepository inputRepository,
                               @NonNull OutputRepository outputRepository,
                               @NonNull CommandRepository commandRepository) {
        this.senderId = senderId;
        this.senderRepository = senderRepository;
        this.inputRepository = inputRepository;
        this.outputRepository = outputRepository;
        this.commandRepository = commandRepository;
    }

    @Override
    public Sender execute() {
        return buildSender(senderRepository.get(senderId),
                inputRepository.getForSender(senderId),
                outputRepository.getForSender(senderId),
                commandRepository.getForSender(senderId));
    }

    private Sender buildSender(Sender sender, List<Port> inputs, List<Port> outputs, List<Command> commands) {
        return new Sender(sender.getId(), sender.getName(), sender.getNumber(),
                sender.getPin(), inputs, outputs, commands);
    }
}
