package it.webscience.kpeople.dal.process;

import it.webscience.kpeople.be.Process;
import it.webscience.kpeople.be.ProcessState;
import it.webscience.kpeople.be.ProcessType;
import it.webscience.kpeople.be.User;
import it.webscience.kpeople.dal.dataTraceClass.DataTraceClassFactory;

import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * factory per le classi HPM.
 * @author dellanna
 */
public class ProcessFactory {

    /**
     * factory per l'oggetto Process.
     * @param rs resultset
     * @return istanza dell'oggetto Process
     * @throws SQLException label colonne non valido
     */
    public static Process createProcess(final ResultSet rs)
            throws SQLException {
        Process process = new Process();

        process.setActive(rs.getBoolean("IS_ACTIVE"));
        process.setDateCreated(rs.getDate("DATE_CREATED"));
        process.setDateDue(rs.getDate("DATE_DUE"));
        process.setDescription(rs.getString("DESCRIPTION"));
        process.setHpmProcessId(rs.getString("HPM_PROCESS_ID"));
        process.setIdProcess(rs.getInt("ID_PROCESS"));
        process.setName(rs.getString("NAME"));
        process.setPrivate(rs.getBoolean("IS_PRIVATE"));

        if (rs.getInt("ID_PROCESS_STATE") > 0) {
            process.setProcessState(new ProcessState());
            process.getProcessState().setIdProcessState(
                    rs.getInt("ID_PROCESS_STATE"));
        }

        if (rs.getInt("ID_USER_OWNER") > 0) {
            process.setOwner(new User());
            process.getOwner().setIdUser(rs.getInt("ID_USER_OWNER"));
        }

        if (rs.getInt("ID_PROCESS_TYPE") > 0) {
            process.setProcessType(new ProcessType());
            process.getProcessType().setIdProcessType(
                    rs.getInt("ID_PROCESS_TYPE"));
        }

        DataTraceClassFactory.createDataTraceClass(process, rs);

        return process;
    }

    /**
     * factory per l'oggetto ProcessState.
     * @param rs resultset
     * @return istanza dell'oggetto ProcessState
     * @throws SQLException label colonne non valido
     */
    public static ProcessState createProcessState(final ResultSet rs)
            throws SQLException {
        ProcessState ps = new ProcessState();

        ps.setIdProcessState(rs.getInt("ID_PROCESS_STATE"));
        ps.setDescription(rs.getString("DESCRIPTION"));
        ps.setProcessState(rs.getString("PROCESS_STATE"));

        return ps;
    }
}
