package it.webscience.kpeople.service.process;

import it.webscience.kpeople.service.datatypes.Process;
import it.webscience.kpeople.service.datatypes.ProcessType;
import it.webscience.kpeople.service.datatypes.User;
import it.webscience.kpeople.service.exception.KPeopleServiceException;

import org.junit.Test;

public class UpdateProcessTest {

    /**
     * test del metodo getProcessByHpmId.
     */
    @Test
    public void testUpdateProcess() {

        ProcessService service = new ProcessService();

        User user = new User();
        user.setIdUser(4);
        user.setHpmUserId("filieri@local.it");

        Process process = new Process();
        process.setIdProcess(1099);
        process.setOwner(user);

        process.setName("aggiorna2");

        process.setDescription("aggiornato");

        process.setPrivate(true);
        ProcessType type = new ProcessType();
        type.setIdProcessType(3);
        process.setProcessType(type);

        process.setHpmProcessId("rda1099");

        //
        // process.setPrivate(false);

        try {
            service.updateProcess(process, user);
            assert (true);
        } catch (KPeopleServiceException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

    }
}
