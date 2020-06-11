package name.xio.xiorkflow.domain.logic;

import java.util.List;

import name.xio.xiorkflow.domain.Process;
import name.xio.xiorkflow.domain.ProcessResult;

public interface ProcessService {

    List listProcess();

    ProcessResult getProcess(String name);

    ProcessResult addProcess(Process process);

    ProcessResult deleteProcess(Process process);

    ProcessResult updateProcess(Process process);

    public static int NULL = -1;

    public static int SUCCESS = 0;

    public static int FAIL = 1;

    public static int FILE_EXIST = 3;

    public static int FILE_NOT_FOUND = 5;

    public static int XML_PARSER_ERROR = 7;

    public static int IO_ERROR = 9;

}
